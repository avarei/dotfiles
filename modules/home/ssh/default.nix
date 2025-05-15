{ config, pkgs, lib, keys, ... }:

{
  home = {
    file.".ssh/authorized_keys".text = keys;
    packages = with pkgs; [
      # gnupg
    ];
  };
}
