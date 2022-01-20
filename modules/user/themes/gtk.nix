{ pkgs, config, options, inputs, ... }:
{

  gtk = {
    enable = true;
    font.name = "Victor Mono SemiBold 12";
    theme = {
      name = "Sweetly";
      package = pkgs.callPackage ./packages/sweetly-gtk-theme {};
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

}