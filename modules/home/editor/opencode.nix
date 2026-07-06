{
  config,
  lib,
  osConfig,
  pkgs,
  pkgs-unstable,
  ...
}: let
  cfg = config.dotfiles.editor.opencode;
in {
  options.dotfiles.editor.opencode.enable = lib.mkEnableOption "opencode";

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.dotfiles.selfhosted.ollama.enable or false;
        message = "dotfiles.editor.opencode requires dotfiles.selfhosted.ollama.enable = true";
      }
    ];

    programs.opencode = {
      enable = true;
      package = pkgs-unstable.opencode;
      extraPackages = [pkgs.yaml-language-server];

      settings = {
        lsp.yaml = {
          command = ["yaml-language-server" "--stdio"];
          extensions = [".yaml" ".yml"];
          initialization.yaml = {
            schemas = {
              "https://json.schemastore.org/kustomization.json" = [
                "kustomization.yaml"
                "kustomization.yml"
              ];
              "https://json.schemastore.org/chart.json" = ["Chart.yaml"];
            };
            format.enable = true;
            validate = true;
          };
        };
        provider.ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama (local)";
          options.baseURL = "http://localhost:11434/v1";
          models = {
            "gemma4:26b" = {
              name = "gemma4:26b";
              options.num_ctx = 32768;
            };
            "qwen3-coder:30b" = {
              name = "qwen3-coder:30b";
              options.num_ctx = 32768;
            };
            "qwen3.5:9b" = {
              name = "qwen3.5:9b";
              options.num_ctx = 32768;
            };
          };
        };
        model = "ollama/gemma4:26b";
      };

      agents = {
        organize = ./organize-prompt.md;
        refactor-references = ./refactor-references-prompt.md;
        kustomize-expert = ./kustomize-expert-prompt.md;
        flux-expert = ./flux-expert-prompt.md;
      };
    };
  };
}
