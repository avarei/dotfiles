# Nix Flakes and Dotfiles

## Server

```sh
sudo nixos-rebuild switch --flake .#server
```

## Desktop

```sh
sudo nixos-rebuild switch --flake .#desktop
```

## MacOS

```sh
darwin-rebuild switch --flake .#macbook
```

## Work

```sh
home-manager switch --flake .#tim@macbook
```

## GPG

for the first time after installation

```sh
gpg --card-status
```

### Setup GPG Key

Change Pin and AdminPin

```sh
gpg --change-pin
```

generate key:

```sh
gpg --expert --full-gen-key
# ECC (sign only)
# Curve 25519
```

generate subkeys

```sh
gpg --list-secret-keys
gpg --expert --edit-key 1234ABC
addkey
```

needs to be run before it can be used.

## Testing

```sh
nix flake check
```

