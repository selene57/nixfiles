{ config, pkgs, options, inputs, ... }:

{ 

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "selene";
  home.homeDirectory = "/home/selene";
  home.packages = with pkgs; [
  ];

  nixpkgs.overlays = with inputs; [
    (import ./config/taffybar/overlay.nix)
  ] ++ taffybar.overlays;

  xsession = {
    enable = true;
    preferStatusNotifierItems = true;
    importedVariables = [ "GDK_PIXBUF_ICON_LOADER" ];

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hpkgs: [
        hpkgs.xmonad-contrib
        hpkgs.xmonad-extras
        hpkgs.xmonad
        hpkgs.taffybar
      ];
      config = ./config/xmonad/xmonad.hs;
    };

  };

  services.taffybar = {
    enable = true;
    package = pkgs.haskellPackages.selene-taffybar;
  };

  # Status Notifier Applet Notification for SNITray in taffybar
  services.status-notifier-watcher.enable = true;

  programs.git = {
    enable = true;
    userName = "selene57";
    userEmail = "selene57.dev@gmail.com";
  };

  programs.neovim = {
    enable = true;
    plugins = [ 
      pkgs.vimPlugins.lightline-vim
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.auto-pairs
      pkgs.vimPlugins.python-syntax
      pkgs.vimPlugins.vim-misc
      #pkgs.vimPlugins.vim-notes
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

  gtk = {
    enable = true;
    font.name = "Victor Mono SemiBold 12";
    theme = {
      name = "Paper";
      package = pkgs.paper-gtk-theme;
    };
  };


  xdg.configFile.rofi = {
    source = ./config/rofi;
    recursive = true;
  };

  home.file = {
      ".config/dunst/dunstrc".source = ./config/dunst/dunstrc;
      ".config/alacritty/alacritty.yml".source = ./config/alacritty/alacritty.yml;
      ".xmonad/startup.sh".source = ./config/xmonad/startup.sh;
  };

}