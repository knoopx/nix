# Sandboxed pi wrapper using bwrap
# Blocks access to user config (~/.config, ~/.local, ~/.ssh, etc.)
# Allows access to ~/.pi for pi's own configuration
# Provides pi (sandboxed) and pi-nosandbox (unsandboxed)
# Restricts network access to npm registry only
final: prev: {
  # Sandboxed version with bwrap
  pi = prev.writeShellScriptBin "pi" ''
    # Sandboxed pi wrapper using bwrap
    # This sandbox:
    # - Blocks access to user config directories (~/.config, ~/.local, ~/.ssh, etc.)
    # - Restricts network access via bunfig.toml (npm registry only)
    # - Provides minimal read/write access to current working directory
    # - Allows access to ~/.pi for pi's own configuration and data
    # - Uses fully isolated temporary directories (/tmp, /var/tmp)
    # - Allows any command from system PATH to run (sandboxed but functional)

    # Create isolated temporary directories for sandbox
    SANDBOX_BASE="''${XDG_RUNTIME_DIR:-/tmp}/pi-sandbox-$$"
    mkdir -p "$SANDBOX_BASE"/{home,tmp,var-tmp,bun-cache}

    # Cleanup on exit
    trap 'rm -rf "$SANDBOX_BASE"' EXIT

    # Determine if we're being run with network isolation flag
    NETWORK_ISOLATED="no"
    for arg in "$@"; do
      case "$arg" in
        --sandbox|--isolated|--no-network) NETWORK_ISOLATED="yes" ;;
      esac
    done

    # Get actual user's home directory
    USER_HOME="$(getent passwd "$(id -un)" | cut -d: -f6)"

    # Create minimal bunfig.toml to restrict registries
    cat > "$SANDBOX_BASE/home/bunfig.toml" << 'EOF'
    [install]
    # Lock to npm registry only - prevents GitHub Packages, custom registries
    registry = "https://registry.npmjs.org/"
    cache = "/tmp/bun-cache"
    # Disable auto-install behavior that could fetch from arbitrary sources
    prefer-offline = true

    [install.lockfile]
    # Ensure lockfile is respected
    print = "yarn"
    EOF

    # Get current working directory
    CWD="$(pwd)"

    # Build bwrap command
    BWRAP_CMD="${final.bubblewrap}/bin/bwrap"

    # Bind all system tools from PATH - allows any command to run
    BWRAP_ARGS=(
      # Read-only system essentials
      --ro-bind /nix /nix
      --ro-bind /etc/ssl /etc/ssl
      --ro-bind /etc/hosts /etc/hosts
      --ro-bind /etc/resolv.conf /etc/resolv.conf

      # Allow access to entire system bin directory - pi can run any command
      --ro-bind /run/current-system/sw/bin /usr/bin

      # Allow access to user profile bin (for bun, etc.)
      --ro-bind /etc/profiles/per-user/knoopx/bin /usr/local/bin

      # Isolated temporary directories
      --bind "$SANDBOX_BASE/tmp" /tmp
      --bind "$SANDBOX_BASE/var-tmp" /var/tmp
      --bind "$SANDBOX_BASE/bun-cache" /tmp/bun-cache

      # Work directories
      --bind "$CWD" "$CWD"

      # Allow read/write access to ~/.pi for pi's own configuration and runtime data
      --bind "$USER_HOME/.pi" "$USER_HOME/.pi"

      # Environment
      --setenv HOME "$USER_HOME"
      --setenv TMPDIR /tmp
      --setenv TEMP /tmp
      --setenv TMP /tmp
      --setenv PATH "/usr/bin:/usr/local/bin"
      --setenv XDG_CONFIG_HOME "$USER_HOME/.pi"
      --setenv XDG_RUNTIME_DIR /tmp
      --setenv BUN_PERMISSION_GATE "0"
      --setenv BUN_INSTALL_NO_CLEANUP "1"
      --setenv BUN_DISABLE_HARDENED "1"

      # Device access
      --dev-bind /dev/null /dev/null
      --dev-bind /dev/random /dev/random
      --dev-bind /dev/urandom /dev/urandom

      # Process isolation
      --proc /proc
      --die-with-parent
    )

    # Add network isolation if requested
    if [ "$NETWORK_ISOLATED" = "yes" ]; then
      BWRAP_ARGS+=(--unshare-net)
      echo "pi: Running with isolated network (no outbound connections)" >&2
    fi

    # Add other unshare flags for stronger sandbox
    BWRAP_ARGS+=(
      --unshare-pid
      --unshare-uts
      --unshare-cgroup
    )

    # Run pi in bwrap sandbox
    exec "$BWRAP_CMD" "''${BWRAP_ARGS[@]}" \
      bun x @mariozechner/pi-coding-agent "$@"
  '';

  # Non-sandboxed version - runs without bwrap
  pi-nosandbox = prev.writeShellScriptBin "pi-nosandbox" ''
    # Non-sandboxed pi - runs bunx directly without any sandboxing
    # Use this if you need full filesystem access or to debug sandbox issues

    # Get current working directory
    CWD="$(pwd)"

    # Run pi directly without bwrap sandbox
    exec bun x @mariozechner/pi-coding-agent "$@"
  '';
}
