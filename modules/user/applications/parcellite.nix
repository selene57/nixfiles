{ pkgs, config, options, inputs, ... }:
{
  services.parcellite = {
    enable = true;
    package = pkgs.clipit;
  };
}
