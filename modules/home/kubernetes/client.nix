{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.dotfiles.kubernetes.cli;
in {
  options.dotfiles.kubernetes.cli = {
    enable = lib.mkEnableOption "kubectl and related CLIs";
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        kubectl
        kubecolor
        kubernetes-helm
        crossplane-cli
        argocd
        fluxcd
      ];
    };
    programs.kubecolor = {
      enable = true;
      enableAlias = true;
      enableZshIntegration = true;
    };
  };
}
