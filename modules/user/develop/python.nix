{ pkgs, config, options, inputs, ... }:
{
  home.packages = with pkgs; [
    nodePackages.pyright
    python3
  ];
}
