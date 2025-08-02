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

