{ config, pkgs, lib, nixvim, ... }:

let
  foo = true;
in {

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
      gopls
      ripgrep # for live_grep
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

    keymaps = config.lib.nixvim.keymaps.mkKeymaps {
      mode = "n";
      options.silent = true;
    }[
      { key = "<C-h>"; action = "<C-w>h"; options.desc = "window up"; }
      { key = "<leader>u"; action = "<cmd>UndotreeToggle<CR>"; options.desc = "toggle undotree"; }
      # find
      { key = "<leader><space>"; action.__raw = "function() Snacks.picker.smart() end"; options.desc = "Smart Find Files"; }
      { key = "<leader>,"; action.__raw = "function() Snacks.picker.buffers() end"; options.desc = "Buffers"; }
      { key = "<leader>/"; action.__raw = "function() Snacks.picker.grep() end"; options.desc = "Grep"; }
      { key = "<leader>ff"; action.__raw = "function() Snacks.picker.files() end"; options.desc = "Find Files"; }
      { key = "<leader>fr"; action.__raw = "function() Snacks.picker.recent() end"; options.desc = "Recent Files"; }
      # git
      { key = "<leader>gb"; action.__raw = "function() Snacks.picker.git_branches() end"; options.desc = "Git Branches"; }
      { key = "<leader>gl"; action.__raw = "function() Snacks.picker.git_log() end"; options.desc = "Git Log"; }
      { key = "<leader>gs"; action.__raw = "function() Snacks.picker.git_status() end"; options.desc = "Git Status"; }
      { key = "<leader>gS"; action.__raw = "function() Snacks.picker.git_stash() end"; options.desc = "Git Stash"; }
      { key = "<leader>gd"; action.__raw = "function() Snacks.picker.git_diff() end"; options.desc = "Git Diff (Hunks)"; }
      { key = "<leader>gB"; action.__raw = "function() Snacks.gitbrowse() end"; mode = ["n" "v"]; options.desc = "Git Browse"; }
      # todo comments
      { key = "<leader>td"; action.__raw = "function() Snacks.picker.todo_comments() end"; options.desc = "Todo"; }
      { key = "<leader>Td"; action.__raw = "function() Snacks.picker.todo_comments({ keywords = {  'TODO', 'FIX', 'FIXME' } }) end"; options.desc = "Todo/Fix/Fixme"; }
      # terminal
      { key = "<C-/>"; action.__raw = "function() Snacks.terminal() end"; options.desc = "Toggle Terminal"; }
      { key = "]]"; action.__raw = "function() Snacks.words.jump(vim.v.count1) end"; mode = ["n" "t"]; options.desc = "Next Reference"; }
      { key = "[["; action.__raw = "function() Snacks.words.jump(-vim.v.count1) end"; mode = ["n" "t"]; options.desc = "Prev Reference"; }
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
        inlayHints = true;
        servers = {
          gopls.enable = true;
          bashls.enable = true;
          helm_ls.enable = true;
          pylsp.enable = true;
          yamlls.enable = true;
        };
        keymaps = {
          silent = true;
          diagnostic = {
            # Navigate in diagnostics
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };

          lspBuf = {
            gd = "definition";
            gD = "references";
            gt = "type_definition";
            gi = "implementation";
            K = "hover";
            "<F2>" = "rename";
          };
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
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        settings.mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };
      };
      undotree = {
        enable = true;
        autoLoad = true;
      };
      gitsigns.enable = true;

      lazy.enable = true; # required (at least) by snacks.dashboard
      which-key.enable = true;
      snacks = {
        enable = true;
        settings = {
          bigfile = {
            enabled = true;
            notify = true;
          };
          notifier = {
            enabled = true;
            timeout = 3000;
          };
          quickfile.enabled = true;
          words = {
            enabled = true;
            debounce = 100;
          };
          dashboard = {
            enabled = true;
            preset = {
              header = "NeoVim";
            };
            sections = [
              { section = "header"; }
              { __raw = ''
              function()
                local in_git = Snacks.git.get_root() ~= nil
                return {
                  section = "terminal",
                  enabled = in_git,
                  icon = " ";
                  title = "Git Status",
                  cmd = "git --no-pager diff --stat -B -M -C",
                  height = 10,
                  indent = 3,
                  ttl = 60,
                }
              end
              ''; }
            ];
          };
          picker.enabled = true;
          gitbrowse.enabled = true;
          input.enabled = true;
          statuscolumn = {
            enabled = true;
            left = ["mark" "sign" "git"];
            right = [ "fold" ];
            folds = {
              open = true;
            };
          };
          win = {
            enabled = true;
            style = "terminal";
          };
          terminal = {
            enabled = true;
          };
        };
      };
      todo-comments.enable = true;
      nvim-surround.enable = true;
    };
    extraPlugins = with pkgs.vimPlugins; [
      yuck-vim
    ];
  };
}
