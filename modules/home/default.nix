{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./editor/neovim.nix
    ./editor/opencode.nix
    ./editor/aider.nix
    ./git.nix
    ../shared/stylix.nix
    ./shell/nushell.nix
    ./shell/zsh.nix
    ./shell/tmux.nix
    ./gpg.nix
    ./gui
    ./kubernetes/client.nix
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

    # Plasma rewrites ~/.gtkrc-2.0 on session start, so home-manager finds
    # an unmanaged file on rebuild. Force overwrite instead of erroring.
    # Key must match home-manager's gtk2 module (uses full homeDirectory path).
    file."${config.home.homeDirectory}/.gtkrc-2.0".force = lib.mkForce true;
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
