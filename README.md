```
        __       __    ___   _    __
    ___/ / ___  / /_  / _/  (_)  / / ___   ___
 _ / _  / / _ \/ __/ / _/  / /  / / / -_) (_-<
(_)\_,_/  \___/\__/ /_/   /_/  /_/  \__/ /___/

# install os
sudo nixos-rebuild switch --flake https://github.com/knoopx/nix/archive/refs/heads/master.zip#hostname

# install home
home-manager switch --flake https://github.com/knoopx/nix/archive/refs/heads/master.zip#username

# update flakes
sudo nix flake update

# build
sudo nixos-rebuild build --flake path:.
# or alternately
nh os switch ~/.dotfiles/

# run in vm
nixos-rebuild build-vm --flake path:.
result/bin/run-desktop-vm-vm

# create live usb image
nix build path:.#nixosConfigurations.live.config.system.build.isoImage

# deploy
sudo nixos-rebuild switch --flake path:.

# repl (:q to quit)
nix repl --expr "builtins.getFlake ''$PWD''"
```

https://noogle.dev/
