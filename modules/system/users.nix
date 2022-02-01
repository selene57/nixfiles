{ pkgs, inputs, ... }:
{

  security.sudo.enable = true;

  users.extraUsers = let
    extraGroups = [
      "audio"
      "adbusers"
      "disk"
      "docker"
      "networkmanager"
      "plugdev"
      "systemd-journal"
      "video"
      "wheel"
    ];
    userDefaults = {
      inherit extraGroups;
      group = "users";
      isNormalUser = true;
      createHome = true;
      shell = pkgs.zsh;
    };
  in {
    selene = userDefaults // {
      name = "selene";
      description = "Selene Hines";
      uid = 1000;
      shell = pkgs.zsh;
    };
  };

  nix.settings.trusted-Users = [ "root" "selene" ];

  imports = [
    inputs.home-manager.nixosModule
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.selene = import ../../users/selene-home.nix;
}
