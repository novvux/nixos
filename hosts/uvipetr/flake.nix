{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
#    nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zapret.url = "github:novvux/zapret-discord-youtube-nix.flake";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" "https://mirror.yandex.ru/nixos" "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" "https://mirror.sjtu.edu.cn/nix-channels/store" ];
#    trusted-substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/" ];
    # Ensure you use the correct public key for the mirror
#    trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
  };

  outputs = { self, nixpkgs, nix-minecraft, sops-nix, zapret, ... }@inputs: {
    nixosConfigurations."uvipetr" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hardware-configuration.nix
        sops-nix.nixosModules.sops
        ./configuration.nix

        # Games
        ./factorio.nix
#        ./terraria.nix

        # Services
        ./beszel.nix
        ./postgres.nix
        ./forgejo.nix
        ./nextcloud.nix
        ./jellyfin.nix
        ./qbittorrent.nix
        ./icecast2.nix
        ./mediawiki.nix
#        ./caddy.nix

        # Life support
        ./frpc.nix 
        ./tailscale.nix
        zapret.nixosModules.default
        ./zapret.nix
        ./yggdrasil.nix

        # Fun
#        ./azkaban.nix

        # User
        ./mit-vm.nix
      ];
    };
  };
}
