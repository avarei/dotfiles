{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.editor.aider;
in {
  options.dotfiles.editor.aider = {
    enable = lib.mkEnableOption "aider";
    ollama = {
      enable = lib.mkEnableOption "local ollama provider";
      baseURL = lib.mkOption {
        type = lib.types.str;
        default = "http://localhost:11434";
      };
      defaultModel = lib.mkOption {
        type = lib.types.str;
        default = "qwen3-coder:30b";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.aider-chat];

    home.file.".aider.conf.yml".text = lib.mkIf cfg.ollama.enable (
      builtins.toJSON {
        model = "ollama_chat/${cfg.ollama.defaultModel}";
        set-env = ["OLLAMA_API_BASE=${cfg.ollama.baseURL}"];
      }
    );

    home.file.".aider.model.settings.yml".text = lib.mkIf cfg.ollama.enable (
      builtins.toJSON [
        {
          name = "ollama_chat/${cfg.ollama.defaultModel}";
          extra_params.num_ctx = 32768;
        }
        {
          name = "ollama_chat/gemma4:26b";
          extra_params.num_ctx = 32768;
        }
      ]
    );
  };
}
