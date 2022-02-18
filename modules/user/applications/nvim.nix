{ pkgs, config, options, inputs, ... }:

let  
  nvim-config-relative-path = ../../../config/nvim;

  neovim-session-manager = pkgs.vimUtils.buildVimPlugin {
    pname = "neovim-session-manager";
    version = "2022-02-03";
    src = pkgs.fetchFromGitHub {
      owner = "Shatur";
      repo = "neovim-session-manager";
      rev = "16bc2ff389fa4e6c51d5bdaee39fa308109bf3d7";
      sha256 = "0KAAV8RIN832OZpOUsVhA41H4aVP+ZEm23xPjmKVkXU=";
    };
  };
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
        # adds session management and context dependent autoloading
        plugin = neovim-session-manager;
        type = "lua";
        config = builtins.readFile (nvim-config-relative-path + /session-manager.lua); 
      }
      {
        # catppuccine theme
        plugin = pkgs.vimPlugins.catppuccin-nvim;
        type = "lua";
        config = builtins.readFile (nvim-config-relative-path + /catppuccin.lua);
      }
      {
        # adds indentation and EOL marks
        plugin = pkgs.vimPlugins.indent-blankline-nvim;
        type = "lua";
        config = builtins.readFile (nvim-config-relative-path + /indent-blankline.lua);
      }
      {
        # custom and easy to configure statusline in lua
        plugin = pkgs.vimPlugins.lualine-nvim;
        type = "lua";
        config = builtins.readFile (nvim-config-relative-path + /lualine.lua);
      }
      {
        # custom and easy buffer bar support
        plugin = pkgs.vimPlugins.bufferline-nvim;
        type = "lua";
        config = builtins.readFile (nvim-config-relative-path + /bufferline.lua);
      }
      {
        # adds functionality to show what has changed in a file for git
        plugin = pkgs.vimPlugins.gitsigns-nvim;
        type = "lua";
        config = builtins.readFile (nvim-config-relative-path + /gitsigns.lua);
      }
      {
        # telescope
        plugin = pkgs.vimPlugins.telescope-nvim;
        type = "lua";
        config = builtins.readFile (nvim-config-relative-path + /telescope.lua);
      }
      {
        # completion engine
        plugin = pkgs.vimPlugins.nvim-cmp;
        type = "lua";
        config = builtins.readFile (nvim-config-relative-path + /cmp.lua);
      }
      {
        # language server config
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        type = "lua";
        config = builtins.readFile (nvim-config-relative-path + /lspconfig.lua);
      }
      {
        # file tree viewer
        plugin = pkgs.vimPlugins.nvim-tree-lua;
        config = builtins.readFile (nvim-config-relative-path + /tree-lua.vim);
      }
      {
        # requires node.js
        plugin = pkgs.vimPlugins.nvim-treesitter;
        type = "lua";
        config = builtins.readFile (nvim-config-relative-path + /treesitter.lua);
      }
      {
        # neorg requires plenary, and requires that treesitter is loaded before neorg
        plugin = pkgs.vimPlugins.neorg;
        type = "lua";
        config = builtins.readFile (nvim-config-relative-path + /neorg.lua);
      }
      {
        # nvim web devicons plugin
        plugin = pkgs.vimPlugins.nvim-web-devicons;
        type = "lua";
        config = builtins.readFile (nvim-config-relative-path + /web-devicons.lua);
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
