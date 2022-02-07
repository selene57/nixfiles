{ pkgs, config, options, inputs, ... }:
{

  xdg.configFile.rofi = {
    source = ../../../config/rofi/light-theme;
    recursive = true;
  };

}