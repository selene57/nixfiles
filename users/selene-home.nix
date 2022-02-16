{ config, pkgs, options, inputs, ... }:

{ 
  
  imports = [
    #../modules/user/applications/alacritty-light-theme.nix
    ../modules/user/applications/alacritty-dark-theme.nix
    ../modules/user/applications/nvim.nix
    #../modules/user/applications/rofi-light-theme.nix
    ../modules/user/applications/rofi-dark-theme.nix
    ../modules/user/shells/zsh.nix
    #../modules/user/themes/sweetly-gtk.nix
    ../modules/user/themes/levuaska-gtk.nix
    #../modules/user/themes/catppuccin-gtk.nix
    ../modules/user/themes/qt.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "selene";
  home.homeDirectory = "/home/selene";
  home.packages = with pkgs; [
  ];

  nixpkgs.overlays = with inputs; [
    (import ../config/taffybar/overlay.nix)
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
      config = ../config/xmonad/xmonad.hs;
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
    extraConfig = {
      init.defaultBranch = "master";
      credential.helper = "gopass";
    };
  };

  home.file = {
      ".config/dunst/dunstrc".source = ../config/dunst/dunstrc;
      ".xmonad/startup.sh".source = ../config/xmonad/startup.sh;
  };

}
