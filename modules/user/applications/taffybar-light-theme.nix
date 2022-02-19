{ pkgs, config, options, inputs, ... }:
{
  nixpkgs.overlays = with inputs; [
    (import ../../../config/taffybar/light-theme/overlay.nix)
  ] ++ taffybar.overlays;

  services.taffybar = {
    enable = true;
    package = pkgs.haskellPackages.selene-taffybar-light;
  };
}
