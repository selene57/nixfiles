{ pkgs, ... }:
{
  imports = [
    ./base-system.nix
    ./fonts.nix
    ./gopass.nix
  ];
}
