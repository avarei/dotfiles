{ config, pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      kubectl
      kubernetes-helm
      crossplane-cli
      argocd
    ];
  };
}
