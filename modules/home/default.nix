{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./editor/neovim.nix
    ./git.nix
    ../shared/stylix.nix
    ./shell/nushell.nix
    ./shell/zsh.nix
    ./shell/tmux.nix
    ./gpg.nix
    ./gui
    ./selfhosted/jellyfin.nix
    ./selfhosted/copyparty.nix
  ];

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };

  home = {
    username = lib.mkDefault "tim";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";

    stateVersion = "24.11";

    keyboard.layout = "us(intl)";

    packages = with pkgs; [
      jq
      yq
      tree
      htop
    ];

    sessionVariables = {
      GTK_IM_MODULE = "simple";
      EDITOR = lib.mkIf config.dotfiles.editor.neovim.enable "nvim";
    };
  };
  programs.nushell.envFile.text = lib.concatStringsSep "\n" (
    [
      "$env.GTK_IM_MODULE = \"simple\";"
    ]
    ++ lib.optional config.dotfiles.gpg-agent.enable "$env.SSH_AUTH_SOCK = ^${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket"
    ++ lib.optional config.dotfiles.editor.neovim.enable "$env.EDITOR = 'nvim'"
  );

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  fonts.fontconfig.enable = true;
}
