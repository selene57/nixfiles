{ pkgs, config, options, inputs, ... }:
{

  home.file = {
      ".config/alacritty/alacritty.yml".source = ../../../config/alacritty/light-theme/alacritty.yml;
  };

}