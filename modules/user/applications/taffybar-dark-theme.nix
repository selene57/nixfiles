{ pkgs, config, options, inputs, ... }:
{
  nixpkgs.overlays = with inputs; [
    (import ../../../config/taffybar/dark-theme/overlay.nix)
  ] ++ taffybar.overlays;

  services.taffybar = {
    enable = true;
    package = pkgs.haskellPackages.selene-taffybar-dark;
  };
}
