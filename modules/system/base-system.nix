{ config, pkgs, options, inputs, ... }:
{
  imports = [
    ./users.nix
  ];

  nixpkgs.overlays = with inputs; [
    (import ../../config/taffybar/light-theme/overlay.nix)
    (import ../../config/taffybar/dark-theme/overlay.nix)
  ] ++ taffybar.overlays;
  
}
