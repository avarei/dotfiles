# Nix Flakes and Dotfiles

## Server

```sh
sudo nixos-rebuild switch --flake .#server
home-manager switch --flake .#tim@server
```

## Desktop

```sh
sudo nixos-rebuild switch --flake .#desktop
home-manager switch --flake .#tim@desktop
```

## MacOS
```sh
darwin-rebuild switch --flake .#macbook
home-manager switch --flake .#tim@macbook
```

## GPG

for the first time after installation
```sh
gpg --card-status
```
needs to be run before it can be used.

## Testing

```sh
nix flake check
```


# TODOs

- [ ] screenshare has black flickers 
  - graphics driver related?
  - only seems to occur on niri
- [ ] keyboard layout wrong in niri and hyprland
- [ ] terminal shortcuts are not working in niri
- [ ] add variables to my flake that can be used in multiple sections
- [ ] swayidle is not working (and not configured
- [ ] swaylock is not configured

