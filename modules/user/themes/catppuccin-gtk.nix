{ pkgs, config, options, inputs, ... }:
{

  gtk = {
    enable = true;
    font.name = "Victor Mono SemiBold 12";
    theme = {
      name = "Catppuccin";
      package = pkgs.callPackage ../../../packages/catppuccin-gtk-theme {};
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

}
