{ config, pkgs, lib, nvf, ... }:

{
  imports = [
    nvf.homeManagerModules.default
  ];

  home = {
    packages = with pkgs; [
      # delve
      # gopls
      # go
      # vimPlugins.nvim-treesitter.builtGrammars.go

    ];
  };
  

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        options = {
          mouse = "a";


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
        clipboard = {
          enable = true;
          registers = "unnamedplus";
        };
        # clipboard.providers = {  }

        languages = {
          nix.enable = true;
          go = {
            enable = true;
            dap.enable = true;
            # format.enable = true; #TODO: try this
            lsp.enable = true;
            treesitter.enable = true;
          };
          yaml = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          markdown = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
        };
        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };
        theme = {
          enable = true;
          name = "catppuccin";
          # transparent = true;
          style = "mocha";
        };
        visuals.nvim-web-devicons.enable = true;
        statusline.lualine.enable = true;
        notes.todo-comments.enable = true;
        utility.surround.enable = true;
        
        # autocomplete.blink-cmp.enable = true;

      };

    };
  };
}
