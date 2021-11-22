{ config, pkgs, options, inputs, ... }:
{
  imports = [
    ./users.nix
  ];

  nixpkgs.overlays = with inputs; [
    (import ./config/taffybar/overlay.nix)
  ] ++ taffybar.overlays;
  
}
