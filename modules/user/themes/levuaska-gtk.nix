{ pkgs, config, options, inputs, ... }:
{

  gtk = {
    enable = true;
    font.name = "Victor Mono SemiBold 12";
    theme = {
      name = "Levuaska";
      package = pkgs.callPackage ../../../packages/levuaska-gtk-theme {};
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

}