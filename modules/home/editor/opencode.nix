{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.editor.opencode;
in {
  options.dotfiles.editor.opencode = {
    enable = lib.mkEnableOption "opencode";
    ollama = {
      enable = lib.mkEnableOption "local ollama provider";
      baseURL = lib.mkOption {
        type = lib.types.str;
        default = "http://localhost:11434/v1";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.opencode
      pkgs.yaml-language-server
    ];

    xdg.configFile."opencode/organize-prompt.md".source = ./organize-prompt.md;
    xdg.configFile."opencode/refactor-references-prompt.md".source = ./refactor-references-prompt.md;
    xdg.configFile."opencode/kustomize-expert-prompt.md".source = ./kustomize-expert-prompt.md;
    xdg.configFile."opencode/flux-expert-prompt.md".source = ./flux-expert-prompt.md;

    xdg.configFile."opencode/opencode.json".text = builtins.toJSON ({
        "$schema" = "https://opencode.ai/config.json";
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
      }
      // lib.optionalAttrs cfg.ollama.enable {
        provider.ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama (local)";
          options.baseURL = cfg.ollama.baseURL;
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
        agent.general.prompt = ''
          When delegating to a subagent using the task tool, you MUST include a non-empty `description` field that briefly summarises what you are asking the subagent to do (e.g. "Review the HelmRelease for app-x"). Omitting `description` is an error.
        '';
        agent.organize = {
          description = "File organization agent";
          mode = "primary";
          model = "ollama/qwen3.5:9b";
          prompt = "{file:./organize-prompt.md}";
        };
        agent.refactor-references = {
          description = "Updates references to moved files across the project";
          mode = "subagent";
          model = "ollama/gemma4:26b";
          prompt = "{file:./refactor-references-prompt.md}";
        };
        agent.kustomize-expert = {
          description = "Authors, reviews, and debugs Kustomize bases and overlays";
          mode = "subagent";
          model = "ollama/gemma4:26b";
          prompt = "{file:./kustomize-expert-prompt.md}";
        };
        agent.flux-expert = {
          description = "Authors, reviews, and debugs FluxCD GitOps configurations";
          mode = "subagent";
          model = "ollama/gemma4:26b";
          prompt = "{file:./flux-expert-prompt.md}";
        };
      });
  };
}
