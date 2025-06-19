{ config, pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      moonlight-qt
    ];
  };
}
