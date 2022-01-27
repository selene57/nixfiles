{ pkgs, config, options, inputs, ... }:

  programs.zsh = {
    enable = true;
    syntaxHighlighting = {
      enable = true;
    };
    shellAliases = {
      system-build = "sudo nixos-rebuild switch --flake .#"
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "ar-round";
    };
  };

}