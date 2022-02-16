{ config, pkgs, options, inputs, ... }:

{
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "curses";
  };
  environment.systemPackages = with pkgs; [
    gnupg
    pinentry-gnome
  ];
}
