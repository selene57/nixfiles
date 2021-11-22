{
  description = "A configurable NixOS system.";

  inputs = {

    nixpkgs = {
    	url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };

    home-manager = {
    	url = "github:nix-community/home-manager/master";
    	inputs.nixpkgs.follows = "nixpkgs";
    };

    xmonad = {
    	url = "github:xmonad/xmonad";
    	inputs.nixpkgs.follows = "nixpkgs";
    };

    xmonad-contrib = {
    	url = "github:xmonad/xmonad-contrib";
    	inputs.nixpkgs.follows = "nixpkgs";
    };

    taffybar = {
    	url = path:./config/taffybar/taffybar;
    	inputs.nixpkgs.follows = "nixpkgs";
    };

    notifications-tray-icon = {
    	url = github:IvanMalison/notifications-tray-icon/master;
    };
  };


  outputs = inputs@{

    self, nixpkgs, home-manager, taffybar, xmonad,
    xmonad-contrib, notifications-tray-icon

  }:
  let
    mkConfig =
      args@
      { system ? "x86_64-linux"
      , baseModules ? []
      , modules ? []
      , specialArgs ? {}
      , ...
      }:
    nixpkgs.lib.nixosSystem (args // {
      inherit system;
      modules = baseModules ++ modules;
      specialArgs = { inherit inputs; } // specialArgs;
    });
    systemFilenames = builtins.attrNames (builtins.readDir ./system);
    systemNameFromFilename = filename: builtins.head (builtins.split "\\." filename);
    mkConfigurationParams = filename: {
      name = systemNameFromFilename filename;
      value = {
        modules = [ (./system + ("/" + filename)) ];
      };
    };
    defaultConfigurationParams =
      builtins.listToAttrs (map mkConfigurationParams systemFilenames);
      customParams = {};
  in
  {
    nixosConfigurations = builtins.mapAttrs (systemName: params:
    let systemParams =
      if builtins.hasAttr systemName customParams
      then (builtins.getAttr systemName customParams)
      else {};
    in mkConfig (params // systemParams)
    ) defaultConfigurationParams;
  };
}
