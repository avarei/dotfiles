# Nix Flakes and Dotfiles

## Testing

```sh
nix flake check
```

## Profiles

Each system has it's own profile. At the moment I maintain

- Desktop
- Server
- MacBook
- Work

### Server

```sh
sudo nixos-rebuild switch --flake .#server
```

### Desktop

```sh
sudo nixos-rebuild switch --flake .#desktop
```

### MacOS

```sh
darwin-rebuild switch --flake .#macbook
```

### Work

```sh
home-manager switch --flake .#tim@work
```

## GPG

when the keys change run:

```sh
gpg --card-status
```

### Setup GPG Key

Change Pin and AdminPin

```sh
gpg --change-pin
```

#### Generate key

```sh
# either 
gpg --expert --full-gen-key
# or
gpg --card-edit
admin
key-attr
generate
```

#### Generate subkeys

```sh
gpg --list-secret-keys
gpg --expert --edit-key 1234ABC
addkey
```

### Generate new identity

```sh
gpg --list-secret-keys
gpg --expert --edit-key 1234ABC
adduid
```

### Create Public Key with specific identity

A fido2 key can be seperately configured on the system to allow sudo and logins
to be done with a security key.

## Initialization

Run `:DirtytalkUpdate` on first vim use to download the language.
