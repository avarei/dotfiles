{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.dotfiles.editor.neovim;
in {
  options.dotfiles.editor.neovim = {
    enable = lib.mkEnableOption "neovim";
    spellcheck.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf cfg.enable {
    home = {packages = with pkgs; [go];};

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

            winborder = "rounded"; # add rounded border around flaoting windows
          };
          clipboard = {
            enable = true;
            registers = "unnamedplus";
          };
          # clipboard.providers = {  }
          lsp = {
            enable = true;
            lspSignature = {
              enable = true;
              setupOpts = {
                hint_prefix = " ";
                hint_inline = lib.generators.mkLuaInline "function() return true end";
              };
            };

            formatOnSave = true;
            inlayHints.enable = true;
          };
          spellcheck = lib.mkIf cfg.spellcheck.enable {
            enable = true;
            languages = ["en" "de"];
            programmingWordlist.enable = true; # NOTE: run :DirtytalkUpdate on first use
          };
          languages = {
            nix = {
              enable = true;
              format.enable = true;
              lsp.enable = true;
              treesitter.enable = true;
            };
            go = {
              enable = true;
              dap.enable = true;
              # format.enable = true; #TODO: try this
              lsp.enable = true;
              treesitter.enable = true;
            };
            python = {
              enable = true;
              dap.enable = true;
              format.enable = true;
              lsp.enable = true;
              treesitter.enable = true;
            };
            nu = {
              enable = true;
              lsp.enable = true;
              treesitter.enable = true;
            };
            yaml = {
              enable = true;
              lsp.enable = false;
              treesitter.enable = true;
            };
            markdown = {
              enable = true;
              format.enable = true;
              lsp.enable = true;
              treesitter.enable = true;
            };
            helm = {
              enable = true;
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
          };
          visuals.nvim-web-devicons.enable = true;
          statusline.lualine = {
            enable = true;
          };
          notes.todo-comments.enable = true;
          utility.surround.enable = true;
          utility.direnv.enable = true;
          binds.whichKey.enable = true;
          git = {
            enable = true;
            git-conflict.enable = true;
          };

          telescope = {
            enable = true;
            mappings = {
              findFiles = "<leader><space>";
              liveGrep = "<leader>/";
              buffers = "<leader>,";
            };
          };
          filetree = {
            neo-tree = {
              enable = true;
              setupOpts = {
                filesystem = {
                  hijack_netrw_behavior = "open_default";
                };
              };
            };
          };

          autocomplete.nvim-cmp.enable = true;
          diagnostics = {
            enable = true;
            config = {
              signs.text = lib.generators.mkLuaInline ''
                {
                  [vim.diagnostic.severity.ERROR] = "󰅚 ",
                  [vim.diagnostic.severity.WARN] = "󰀪 ",
                }
              '';
              # virtual_lines = true; # clashes with lspSignature visually
            };
          };
          autopairs.nvim-autopairs.enable = true;
          tabline = {nvimBufferline.enable = true;};
          notify.nvim-notify.enable = true;
          keymaps = [
            {
              key = "<Find>";
              mode = ["n" "v" "o" "i"];
              silent = true;
              action = "<Home>";
            }
            {
              key = "<Select>";
              mode = ["n" "v" "o" "i"];
              silent = true;
              action = "<End>";
            }
            {
              key = "<leader>e";
              mode = ["n"];
              silent = true;
              action = "<Cmd>Neotree<CR>";
            }
          ];
        };
      };
    };
  };
}
