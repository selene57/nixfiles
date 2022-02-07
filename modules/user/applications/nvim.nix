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
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.auto-pairs
      pkgs.vimPlugins.python-syntax
      pkgs.vimPlugins.plenary-nvim

      {
        # catppucine theme
        plugin = pkgs.vimPlugins.catppuccin-nvim;
        config = lua ''
          require("indent_blankline").setup {
              transparent_background = false,
              term_colors = false,
              styles = {
                comments = "italic",
                functions = "italic",
                keywords = "italic",
                strings = "NONE",
                variables = "italic",
              },
              integrations = {
                treesitter = true,
                native_lsp = {
                  enabled = true,
                  virtual_text = {
                    errors = "italic",
                    hints = "italic",
                    warnings = "italic",
                    information = "italic",
                  },
                  underlines = {
                    errors = "underline",
                    hints = "underline",
                    warnings = "underline",
                    information = "underline",
                  },
                },
                lsp_trouble = false,
                cmp = true,
                lsp_saga = false,
                gitgutter = false,
                gitsigns = true,
                telescope = true,
                nvimtree = {
                  enabled = true,
                  show_root = false,
                  transparent_panel = false,
                },
                which_key = false,
                indent_blankline = {
                  enabled = true,
                  colored_indent_levels = true,
                },
                dashboard = false,
                neogit = false,
                vim_sneak = false,
                fern = false,
                barbar = false,
                bufferline = true,
                markdown = false,
                lightspeed = false,
                ts_rainbow = false,
                hop = false,
                notify = false,
                telekasten = false,
              }
          }
          vim.cmd[[colorscheme catppuccin]]
        '';
      }

      {
        # indent_blankline plugin -- adds indentation and EOL marks
        plugin = pkgs.vimPlugins.indent-blankline-nvim;
        config = lua ''
          vim.opt.termguicolors = true
          vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
          vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
          vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
          vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
          vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
          vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

          vim.opt.list = true
          vim.opt.listchars:append("space:⋅")
          vim.opt.listchars:append("eol:↴")

          require("indent_blankline").setup {
              space_char_blankline = " ",
              char_highlight_list = {
                  "IndentBlanklineIndent1",
                  "IndentBlanklineIndent2",
                  "IndentBlanklineIndent3",
                  "IndentBlanklineIndent4",
                  "IndentBlanklineIndent5",
                  "IndentBlanklineIndent6",
              },
          }
        '';
      }

      {
        # lualine plugin -- custom and easy to configure statusline in Lua
        plugin = pkgs.vimPlugins.lualine-nvim;
        config = lua ''
          require('lualine').setup {
            options = {
              icons_enabled = true,
              theme = 'catppuccin',
              component_separators = { left = '', right = ''},
              section_separators = { left = '', right = ''},
              disabled_filetypes = {},
              always_divide_middle = true,
            },
            sections = {
              lualine_a = {'mode'},
              lualine_b = {'branch', 'diff', 'diagnostics'},
              lualine_c = {'filename'},
              lualine_x = {'encoding', 'fileformat', 'filetype'},
              lualine_y = {'progress'},
              lualine_z = {'location'}
            },
            inactive_sections = {
              lualine_a = {},
              lualine_b = {},
              lualine_c = {'filename'},
              lualine_x = {'location'},
              lualine_y = {},
              lualine_z = {}
            },
            tabline = {},
            extensions = {}
          }
        '';
      }

      {
        # bufferline plugin -- custom and easy buffer support
        plugin = pkgs.vimPlugins.bufferline-nvim;
        config = lua ''
          require("bufferline").setup {
            -- Defaults configuration options
          }
        '';
      }

      {
        # gitsigns plugin -- adds functionality to show what has changed in a file for git
        plugin = pkgs.vimPlugins.gitsigns-nvim;
        config = lua ''
          require('gitsigns').setup {

          }
        '';
      }

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
        '' + ''
        nnoremap <C-n> :NvimTreeToggle<CR>
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
                ["core.norg.qol.toc"] = {}, -- Generate automatic table of contents
                ["core.keybinds"] = { -- Allows configuring of keybinds
                    config = {
                        default_keybinds = true, -- generate default keybinds
                        neorg_leader = "<LocalLeader>"
                    },
                },
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
        # nvim web devicons plugin
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

    ];
    #settings = { };
    extraConfig = ''
      set mouse=a
      set noshowmode
      set pastetoggle=<F2>
      set clipboard+=unnamedplus
      filetype plugin on
      let mapleader = " "
      let maplocalleader = "\\"

      " hybrid line numbers
      set nu rnu

      " termguicolors
      set termguicolors

    '';
  };

}