# Nix Flakes and Dotfiles

## Linux

```sh
sudo nixos-rebuild switch --flake .#x86_64-linux
```

## MacOS
```sh
darwin-rebuild switch --flake .#macbook
```

## Home-Manager
```sh
home-manager switch --flake .#tim@macbook
```

## Testing

```sh
nix flake check
```

