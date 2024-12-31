{ config, pkgs, lib, nixvim, ... }:


{
  imports = [
    nixvim.homeManagerModules.nixvim
  ];
  home = {
    packages = with pkgs; [
      # git # Required for lazy.nvim
      helm-ls
      yaml-language-server
      yamllint
      vale # linter for text and markdown
    ];
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = true;

    globals.mapleader = " ";

    opts = {
      clipboard = "unnamedplus"; # use system clipboard
      completeopt = [ "menu" "menuone" "noselect" ];
      mouse = "a"; # allow the mouse to be used in nvim

      # Tab
      tabstop = 2; # number of visual spaces per TAB
      softtabstop = 2; # number of spaceing tab when editing
      shiftwidth = 2; # insert 2 spaces on a tab
      expandtab = true; # tabs will be converted to spaces

      # Ui Config
      number = true; # show absolute number
      relativenumber = true; # add numbers to each line on the left side
      splitbelow = true; # open new vertical split bottom
      splitright = true; # open new horizontal splits right
      showmode = false; # remove insert mode hint

      incsearch = true; # search as characters are entered
      ignorecase = true; # ignore case in searches by default
      smartcase = true; # make case sensitive if uppercase letter is entered
    };

    keymaps = [
      {
        action = "<C-w>h";
        key = "<C-h>";
        mode = "n";
        options = {
          desc = "window up";
        };
      }
    ];

    plugins = {
      web-devicons.enable = true;
      lualine.enable = true;
      treesitter = {
        enable = true;
	      settings = {
          highlight.enable = true;
	        indent.enable = true;
	      };
	      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          json
          make
          markdown
          nix
          regex
          vim
          vimdoc
          xml
          yaml
          go
          python
        ];
      };
      treesitter-context = {
        enable = true;
        settings = {
          max_lines = 0;
          line_numbers = true;
        };
      };
      lsp = {
        enable = true;
        servers = {
          gopls.enable = true;
          bashls.enable = true;
          helm_ls.enable = true;
          pylsp.enable = true;
          yamlls.enable = true;
        };
      };
      lint = {
        enable = true;
        lintersByFt = {
          text = ["vale"];
          markdown = ["vale"];
          yaml = ["yamllint"];
        };
      };
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };
    };

  };

  programs.zsh = {
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };
  };
}
