{ pkgs, config, options, inputs, ... }:
{

  home.file = {
      ".config/alacritty/alacritty.yml".source = ../../../config/alacritty/dark-theme/alacritty.yml;
  };

}