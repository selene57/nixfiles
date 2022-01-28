{ pkgs, config, options, inputs, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      system-build = "sudo nixos-rebuild switch --flake .#";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    plugins = [
      {
        name = "zsh-autopair";
        src = pkgs.fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "9d003fc02dbaa6db06e6b12e8c271398478e0b5d";
          sha256 = "hwZDbVo50kObLQxCa/wOZImjlH4ZaUI5W5eWs/2RnWg=";
        };
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
          sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      {
        name = "zsh-pure-prompt";
        src = pkgs.fetchFromGitHub {
          owner = "sindresorhus";
          repo = "pure";
          rev = "67a80dc72fb2ae9bebb3cffb3d6f789482c2f933";
          sha256 = "CI2ontloLNIzUJghZzPZ2UPbIS+cJAfKvKeetwvW6vg=";
        };
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "fast-syntax-highlighting";
          rev = "585c089968caa1c904cbe926ff04a1be9e3d8f42";
          sha256 = "x+4C2u03RueNo6/ZXsueqmYoPIpDHnKAZXP5IiKsidE=";
        };
      }
      {
        name = "zsh-system-clipboard";
        src = pkgs.fetchFromGitHub {
          owner = "kutsan";
         repo = "zsh-system-clipboard";
          rev = "42c33875b17aa9d40005f44984512498167d03d3";
          sha256 = "Bxffdgm8fGHnQLsqUiAC7YmApRmLSnAx+73g9mtsFEU=";
        };
      }
    ];
    initExtra = ''
      autoload -U promptinit; promptinit
      prompt pure
    '';
  };
}