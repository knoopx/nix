final: prev: {
  pi = prev.writeShellScriptBin "pi" ''
    exec bunx @mariozechner/pi-coding-agent "$@"
  '';

  pi-sandbox = prev.writeShellScriptBin "pi-sandbox" ''
    SANDBOX_BASE="''${XDG_RUNTIME_DIR:-/tmp}/pi-sandbox-$$"
    mkdir -p "$SANDBOX_BASE"/{tmp,var-tmp,bun-cache}

    trap 'rm -rf "$SANDBOX_BASE"' EXIT

    USER_HOME="$(getent passwd "$(id -un)" | cut -d: -f6)"

    BWRAP_CMD="${final.bubblewrap}/bin/bwrap"
    BWRAP_ARGS=(
      --ro-bind /nix /nix
      --ro-bind /etc/static /etc/static
      --ro-bind /etc/ssl /etc/ssl
      --ro-bind /etc/hosts /etc/hosts
      --ro-bind /etc/resolv.conf /etc/resolv.conf
      --ro-bind /run/current-system/sw/bin /usr/bin
      --ro-bind "$(getent passwd "$(id -un)" | cut -d: -f6)/.nix-profile/bin" /usr/local/bin
      --ro-bind /etc/profiles/per-user/$(id -un)/bin /usr/local/per-user-bin
      --ro-bind /run/current-system/sw/lib /usr/lib
      --symlink usr/lib /lib

      --bind "$SANDBOX_BASE/tmp" /tmp
      --bind "$SANDBOX_BASE/var-tmp" /var/tmp
      --bind "$SANDBOX_BASE/bun-cache" /tmp/bun-cache
      --bind "$USER_HOME/.pi" "$USER_HOME/.pi"

      --dev /dev
      --clearenv

      --setenv HOME "$USER_HOME"
      --setenv TMPDIR /tmp
      --setenv PATH "/usr/bin:/usr/local/bin:/usr/local/per-user-bin"
      --setenv XDG_CONFIG_HOME "$USER_HOME/.pi"
      --setenv LANG "en_US.UTF-8"
      --setenv BUN_PERMISSION_GATE "0"
      --setenv BUN_INSTALL_NO_CLEANUP "1"
      --setenv BUN_DISABLE_HARDENED "1"

      --proc /proc
      --die-with-parent

      --unshare-pid
      --unshare-uts
      --unshare-cgroup
      --share-net

      --bind "$PWD" "$PWD"
      --chdir "$PWD"
    )

    exec "$BWRAP_CMD" "''${BWRAP_ARGS[@]}" \
      ${final.bun}/bin/bunx @mariozechner/pi-coding-agent "$@"
  '';
}
