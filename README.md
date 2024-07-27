# kOS

Minimal Gnome configuration using NixOS

## Install kOS

```bash
sudo nixos-rebuild switch --flake https://github.com/knoopx/nix/archive/refs/heads/master.zip#hostname
```

## Install dot files only

```bash
home-manager switch --flake https://github.com/knoopx/nix/archive/refs/heads/master.zip#username
```

## Development

```bash
# update flakes
sudo nix flake update

# build
sudo nixos-rebuild build --flake path:.

# run in vm
nixos-rebuild build-vm --flake path:.
result/bin/run-desktop-vm-vm

# deploy
sudo nixos-rebuild switch --flake path:.
```

## Credits

- https://github.com/Misterio77/nix-starter-configs/
