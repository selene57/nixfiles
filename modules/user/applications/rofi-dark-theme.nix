{ pkgs, config, options, inputs, ... }:
{

  xdg.configFile.rofi = {
    source = ../../../config/rofi/dark-theme;
    recursive = true;
  };

}