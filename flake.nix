{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    freesmlauncher = {
      url = "github:FreesmTeam/FreesmLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

#    zapret.url = "git+https://codeberg.org/VOXEL0798/zapret-discord-youtube-nix.flake.git";
    zapret.url = "github:novvux/zapret-discord-youtube-nix.flake";
#    proxy-suite.url = "github:FUFSoB/proxy-suite-flake";
  };

  nixConfig = {
#    extra-substituters = [ "https://noctalia.cachix.org" "https://mirror.yandex.ru/nixos/" ];
#    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    extra-substituters = [ "https://mirror.yandex.ru/nixos/" ];
  };



  outputs = { self, nixpkgs, zen-browser, zapret, mangowm, freesmlauncher, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          mangowm.nixosModules.mango
          zapret.nixosModules.default
          ./hardware-configuration.nix
          ./disks.nix
          ./configuration.nix
          ./zapret.nix

#          ./i2p.nix
          ./yggdrasil.nix
          ./tailscale.nix
        ];
      };
    };
  };
}
