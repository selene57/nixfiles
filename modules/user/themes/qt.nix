{ pkgs, config, options, inputs, ... }:
{

  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "gtk2";
      package = null;
    };
  };

}