{ pkgs, inputs, ... }:
{
  
  # Enable the gtk icon cache
  #gtk.iconCache.enable = true;

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      emacs-all-the-icons-fonts
      emojione
      fira-code
      fira-mono
      font-awesome-ttf
      iosevka
      noto-fonts-emoji
      roboto
      source-code-pro
      source-sans-pro
      source-serif-pro
      twemoji-color-font
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FantasqueSansMono" ]; })
    ];
    fontconfig = {
      allowBitmaps = true;
      useEmbeddedBitmaps = true;
      defaultFonts = {
        monospace = [ "Source Code Pro" ];
        sansSerif = [ "Roboto" ];
        serif     = [ "Source Serif Pro" ];
      };
    };
  };
  
}