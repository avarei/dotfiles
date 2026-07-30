{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.selfhosted.ai-stack;
  networkName = "ai-stack";
  serviceNames = [
    "podman-hermes-agent"
    "podman-firecrawl-redis"
    "podman-firecrawl"
  ];
in {
  options.dotfiles.selfhosted.ai-stack = {
    enable = lib.mkEnableOption "AI stack (hermes-agent, lmstudio, firecrawl)";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      hermes-agent = {
        image = "nousresearch/hermes-agent";
        autoStart = false;
        ports = ["8080:8080"];
        environment = {
          OLLAMA_BASE_URL = "http://host.docker.internal:11434";
        };
        extraOptions = [
          "--network=${networkName}"
          "--add-host=host.docker.internal:host-gateway"
        ];
      };

      firecrawl-redis = {
        image = "redis:alpine";
        autoStart = false;
        extraOptions = ["--network=${networkName}"];
      };

      firecrawl = {
        image = "ghcr.io/mendableai/firecrawl";
        autoStart = false;
        ports = ["3002:3002"];
        environment = {
          REDIS_URL = "redis://firecrawl-redis:6379";
          REDIS_RATE_LIMIT_URL = "redis://firecrawl-redis:6379";
        };
        extraOptions = ["--network=${networkName}"];
        dependsOn = ["firecrawl-redis"];
      };
    };

    systemd.services =
      lib.genAttrs serviceNames (_: {
        after = ["podman-ai-network.service"];
        requires = ["podman-ai-network.service"];
      })
      // {
        podman-ai-network = {
          description = "Create podman network for AI stack";
          after = ["network.target"];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.podman}/bin/podman network create --ignore ${networkName}";
            ExecStop = "${pkgs.podman}/bin/podman network rm --force ${networkName}";
          };
        };
        ai-stack = {
          description = "AI Stack (hermes-agent, firecrawl)";
          after = ["podman-ai-network.service"];
          requires = ["podman-ai-network.service"];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.systemd}/bin/systemctl start ${lib.concatMapStringsSep " " (n: "${n}.service") serviceNames}";
            ExecStop = "${pkgs.systemd}/bin/systemctl stop ${lib.concatMapStringsSep " " (n: "${n}.service") (lib.reverseList serviceNames)}";
          };
        };
      };
  };
}
