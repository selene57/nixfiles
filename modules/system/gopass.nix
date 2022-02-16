{ config, pkgs, options, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    gopass
    git-credential-gopass
  ];
}
