{ pkgs, config, options, inputs, ... }:

let
  lua = text: ''
    lua << EOF
    ${text}
    EOF
  '';
in {
  home.sessionVariables = { EDITOR = "nvim"; };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = [
      # plugins are unordered, but any configs attached are put at top of init.vim in order
      # Functionality
      pkgs.vimPlugins.lightline-vim
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.auto-pairs
      pkgs.vimPlugins.python-syntax
      pkgs.vimPlugins.plenary-nvim

      {
        # telescope
        plugin = pkgs.vimPlugins.telescope-nvim;
        config = lua ''
          
        '';
      }

      {
        # completion engine
        plugin = pkgs.vimPlugins.nvim-cmp;
        config = lua ''
          
        '';
      }

      {
        # file tree view
        plugin = pkgs.vimPlugins.nvim-tree-lua;
        config = lua ''
          require'nvim-tree'.setup {
            disable_netrw       = true,
            hijack_netrw        = true,
            open_on_setup       = false,
            ignore_ft_on_setup  = {},
            auto_close          = false,
            open_on_tab         = false,
            hijack_cursor       = false,
            update_cwd          = false,
            update_to_buf_dir   = {
              enable = true,
              auto_open = true,
            },
            diagnostics = {
              enable = false,
              icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
              }
            },
            update_focused_file = {
              enable      = false,
              update_cwd  = false,
              ignore_list = {}
            },
            system_open = {
              cmd  = nil,
              args = {}
            },
            filters = {
              dotfiles = false,
              custom = {}
            },
            git = {
              enable = true,
              ignore = true,
              timeout = 500,
            },
            view = {
              width = 30,
              height = 30,
              hide_root_folder = false,
              side = 'left',
              auto_resize = false,
              mappings = {
                custom_only = false,
                list = {}
              },
              number = false,
              relativenumber = false,
              signcolumn = "yes"
            },
            trash = {
              cmd = "trash",
              require_confirm = true
            }
          }
        '';
      }

      {
        # requires node.js
        plugin = pkgs.vimPlugins.nvim-treesitter;
        config = lua ''
          local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

          parser_configs.norg_meta = {
              install_info = {
                  url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
                  files = { "src/parser.c" },
                  branch = "main"
              },
          }

          parser_configs.norg_table = {
              install_info = {
                  url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
                  files = { "src/parser.c" },
                  branch = "main"
              },
          }

          require'nvim-treesitter.configs'.setup {
            -- One of "all", "maintained" (parsers with maintainers), or a list of languages
            ensure_installed = "all",

            -- Install languages synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- List of parsers to ignore installing
            --ignore_install = { "javascript" },

            highlight = {
              -- `false` will disable the whole extension
              enable = true,

              -- list of language that will be disabled
              --disable = { "c", "rust" },

              -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
              -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
              -- Using this option may slow down your editor, and you may see some duplicate highlights.
              -- Instead of true it can also be a list of languages
              additional_vim_regex_highlighting = false,
            },
          }
        '' + ''
        autocmd VimEnter * TSUpdate
        '';
      }

      {
        # neorg requires plenary, and requires that treesitter is loaded before neorg
        plugin = pkgs.vimPlugins.neorg;
        config = lua ''
          require('neorg').setup {
            -- Tell Neorg what modules to load
            load = {
                ["core.defaults"] = {}, -- Load all the default modules
                ["core.gtd.base"] = {
                    config = {
                        -- workspace =   "example_gtd" , -- assign the workspace,
                        workspace = "home",
                        exclude = { "notes/" }, -- Optional: all excluded files from the workspace are not part of the gtd workflow
                        projects = {
                          show_completed_projects = false,
                          show_projects_without_tasks = false,
                        },
                        custom_tag_completion = true,
                    },
                },
                ["core.norg.completion"] = { config = { engine = "nvim-cmp" } },
                ["core.norg.concealer"] = { -- Allows for use of icons
                    config = {
                        icon_preset = "diamond",
                        markup_preset = "dimmed",
                    },
                },
                ["core.norg.qol.toc"] = {}, -- generate automatic table of contents
                ["core.norg.dirman"] = { -- Manage your directories with Neorg
                    config = {
                        workspaces = {
                            home = "~/neorg",
                            notes = "~/neorg/notes"
                        },
                        index = "index.norg"
                    }
                }
            },
          }

          local neorg_callbacks = require("neorg.callbacks")

          local neorg = require('neorg')
          local function load_completion()
              neorg.modules.load_module("core.norg.completion", nil, {
                  engine = "nvim-cmp" -- Choose your completion engine here
              })
          end

          -- If Neorg is loaded already then don't hesitate and load the completion
          if neorg.is_loaded() then
              load_completion()
          else -- Otherwise wait until Neorg gets started and load the completion module then
              neorg.callbacks.on_event("core.started", load_completion)
          end
        '';
      }

      {
        # neorg requires plenary, and requires that treesitter is loaded before neorg
        plugin = pkgs.vimPlugins.nvim-web-devicons;
        config = lua ''
          require'nvim-web-devicons'.setup {
           -- your personnal icons can go here (to override)
           -- you can specify color or cterm_color instead of specifying both of them
           -- DevIcon will be appended to `name`
           override = {
            zsh = {
              icon = "",
              color = "#428850",
              cterm_color = "65",
              name = "Zsh"
            }
           };
           -- globally enable default icons (default to false)
           -- will get overriden by `get_icons` option
           default = true;
          }
        '';
      }

      # Theme
      pkgs.vimPlugins.papercolor-theme

    ];
    #settings = { };
    extraConfig = ''
      set mouse=a
      set noshowmode
      set pastetoggle=<F2>
      set clipboard+=unnamedplus
      set background=light
      colorscheme PaperColor
      filetype plugin on
      let g:lightline = { 'colorscheme': 'PaperColor' }


      " hybrid line numbers
      set nu rnu

    '';
  };

}