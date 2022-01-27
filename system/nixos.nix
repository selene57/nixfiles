# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, inputs, ... }:

{
  imports = [
    ../modules/system/full-system.nix
    ./hardware-configuration.nix
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    registry.nixpkgs.flake = inputs.nixpkgs;
   };


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.cleanTmpDir = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;
  networking.firewall = {
    allowedTCPPorts = [ 17500 ];
    allowedUDPPorts = [ 17500 ];
  };

  # Enable sound
  hardware.pulseaudio.enable = true;
  sound.enable = true;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = false;
  hardware.video.hidpi.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  alacritty
  anki
  ark
  calibre
  dconf
  discord
  dropbox-cli
  dunst
  feh
  firefox
  gimp
  git
  home-manager
  htop
  libreoffice
  lightlocker
  lollypop
  lxqt.pavucontrol-qt
  manuskript
  nerdfonts
  (pkgs.polybar.override { pulseSupport = true; })
  python3
  rofi
  ruby
  spotify
  sublime
  (pkgs.xfce.thunar.override { thunarPlugins = [pkgs.xfce.thunar-archive-plugin pkgs.xfce.thunar-dropbox-plugin]; })
  vim
  gnome.zenity
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.neovim.enable = true;
  programs.neovim.viAlias = true;

  fonts.fonts = with pkgs; [
    pkgs.ubuntu_font_family
  	noto-fonts
  	noto-fonts-cjk
  	noto-fonts-emoji
  	liberation_ttf
  	fira-code
  	fira-code-symbols
  	mplus-outline-fonts
  	dina-font
  	proggyfonts
  ];
  
  # testing to try to fix scale/resolution
  environment.variables = {
    GDK_SCALE = "0.5";
  };

  # List services that you want to enable:
  services = {
  	printing.enable = true;
    printing.drivers = [pkgs.samsungUnifiedLinuxDriver pkgs.brlaser];
  	xserver = {
  		enable = true;
  		videoDrivers = [ "nvidia" ];
      dpi = 96;
      # taffybar workaround https://github.com/taffybar/taffybar/issues/403#issuecomment-843666681
      gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
      windowManager.xmonad = {
  			enable = true;
  			enableContribAndExtras = true;
  			extraPackages = hpkgs: [
  				hpkgs.xmonad-contrib
  				hpkgs.xmonad-extras
  				hpkgs.xmonad
          hpkgs.taffybar
  			];
  		};
  		desktopManager.xterm.enable = false;
  		displayManager.defaultSession = "none+xmonad";
      displayManager.sessionCommands = ''
        # 1st-Step Taffybar workaround
        systemctl --user import-environment GDK_PIXBUF_MODULE_FILE DBUS_SESSION_BUS_ADDRESS PATH
      '';
      displayManager.lightdm = {
        enable = true;
        greeter = {
          enable = true;
          # package = ;
          # name = ;
        };
        background = ../config/wallpapers/purple-heart-wallpaper.jpg;
      };
  	};
  	picom = {
  		enable = true;
  		shadow = true;
  		fade = true;
  	};
    dbus.packages = with pkgs; [ pkgs.dconf ];
  };

  # taffybar workaround/fix https://github.com/taffybar/taffybar/issues/403#issuecomment-843666681
  gtk.iconCache.enable = true;

  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    environment = {
      QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
    };
    serviceConfig = {
      ExecStart = "${pkgs.dropbox.out}/bin/dropbox";
      ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };
 
  nixpkgs.config = {
  	allowBroken = true;
  	allowUnfree = true;
  	oraclejdk.accept_license = true;
    pulseaudio = true;
  };
  
  # Don't manually change this
  system.stateVersion = "20.09";
}

