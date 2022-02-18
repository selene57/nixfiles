{ config, pkgs, options, inputs, ... }:

{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 8 * 60 * 60;
    maxCacheTtl = 8 * 60 * 60;
    pinentryFlavor = "curses";
  };
  home.packages = with pkgs; [
    gnupg
    pinentry-gnome
  ];
}
