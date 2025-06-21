{pkgs, ...}:
pkgs.writeShellApplication {
  name = "nixos-changelog";
  runtimeInputs = with pkgs; [nix coreutils];
  text = ''
    set -euo pipefail

    # Default to comparing current with previous generation (index 0)
    index=0

    # Parse command line arguments
    case $# in
      0)
        # Use default index 0
        ;;
      1)
        if [[ "$1" =~ ^[0-9]+$ ]]; then
          index="$1"
        else
          echo "Usage: nixos-changelog [index]"
          echo ""
          echo "Where index is the comparison offset:"
          echo "  nixos-changelog 0                  # Compare current with previous (default)"
          echo "  nixos-changelog 1                  # Compare previous with previous-1"
          echo "  nixos-changelog 2                  # Compare previous-1 with previous-2"
          echo ""
          echo "Available generations:"
          nix-env --list-generations -p /nix/var/nix/profiles/system | tail -10
          exit 1
        fi
        ;;
      *)
        echo "Usage: nixos-changelog [index]"
        echo ""
        echo "Where index is the comparison offset:"
        echo "  nixos-changelog 0                  # Compare current with previous (default)"
        echo "  nixos-changelog 1                  # Compare previous with previous-1"
        echo "  nixos-changelog 2                  # Compare previous-1 with previous-2"
        echo ""
        echo "Available generations:"
        nix-env --list-generations -p /nix/var/nix/profiles/system | tail -10
        exit 1
        ;;
    esac    # Helper function to get generation path by index from the end
    get_generation_by_index() {
      local idx="$1"
      local generations
      generations=$(nix-env --list-generations -p /nix/var/nix/profiles/system | awk '{print $1}' | tail -n +1)
      local gen_count
      gen_count=$(echo "$generations" | wc -l)

      if [[ $idx -ge $gen_count ]]; then
        echo "Error: Index $idx is too large. Only $gen_count generations available."
        echo "Available generations:"
        nix-env --list-generations -p /nix/var/nix/profiles/system | tail -10
        exit 1
      fi

      local target_line
      target_line=$((gen_count - idx))
      local gen_num
      gen_num=$(echo "$generations" | sed -n "''${target_line}p")

      if [[ $idx -eq 0 ]]; then
        # Current generation - use main profile
        echo "/nix/var/nix/profiles/system"
      else
        echo "/nix/var/nix/profiles/system-''${gen_num}-link"
      fi
    }

    # Get the two generations to compare based on index
    # index 0: current vs previous
    # index 1: previous vs previous-1
    # etc.
    current_path=$(get_generation_by_index "$index")
    prev_path=$(get_generation_by_index "$((index + 1))")

    # Check if the profile paths exist
    if [[ ! -e "$prev_path" ]]; then
      echo "Error: Previous generation profile not found: $prev_path"
      echo "Available generations:"
      nix-env --list-generations -p /nix/var/nix/profiles/system | tail -10
      exit 1
    fi

    if [[ ! -e "$current_path" ]]; then
      echo "Error: Current generation profile not found: $current_path"
      echo "Available generations:"
      nix-env --list-generations -p /nix/var/nix/profiles/system | tail -10
      exit 1
    fi

    echo "Comparing NixOS generations:"
    echo "  Previous: $prev_path"
    echo "  Current:  $current_path"
    echo ""

    # Run the diff-closures command
    nix store diff-closures "$prev_path" "$current_path"
  '';
}
