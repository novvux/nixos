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
#    probe-rs-rules.url = "github:jneem/probe-rs-rules";

#    zapret.url = "git+https://codeberg.org/VOXEL0798/zapret-discord-youtube-nix.flake.git";
    zapret.url = "github:novvux/zapret-discord-youtube-nix.flake";
#    proxy-suite.url = "github:FUFSoB/proxy-suite-flake";
  };

  nixConfig = {
    substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" "https://mirror.yandex.ru/nixos" "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" "https://mirror.sjtu.edu.cn/nix-channels/store" ];
#    trusted-substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/" ];
    # Ensure you use the correct public key for the mirror
#    trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
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
