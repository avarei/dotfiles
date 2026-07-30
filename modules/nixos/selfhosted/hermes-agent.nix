{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.selfhosted.hermes-agent;
in {
  options.dotfiles.selfhosted.hermes-agent = {
    enable = lib.mkEnableOption "hermes-agent CLI";
  };

  config = lib.mkIf cfg.enable {
    services.hermes-agent.addToSystemPackages = true;
  };
}
