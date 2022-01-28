{ pkgs, config, options, inputs, ... }:

let
  vim-notes = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-notes";
    version = "";
    src = pkgs.fetchFromGitHub {
      owner = "xolox";
      repo = "vim-notes";
      rev = "e465a0a987dbacdf7291688215b8545f8584d409";
      sha256 = "4LoIs5VwNw8cdKuPLTToBtDWAHfa8DIXTnaoE6Jc7qw=";
    };
  };
in {
  home.sessionVariables = { EDITOR = "nvim" };
  
  programs.neovim = {
    enable = true;
    plugins = [ 
      pkgs.vimPlugins.lightline-vim
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.auto-pairs
      pkgs.vimPlugins.python-syntax
      pkgs.vimPlugins.vim-misc
      vim-notes
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
    '';
  };
}