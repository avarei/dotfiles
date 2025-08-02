{ config, pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      kubectl
      kubecolor
      kubernetes-helm
      crossplane-cli
      argocd
    ];
  };
  programs.kubecolor = {
    enable = true;
    enableAlias = true;
  };
}
