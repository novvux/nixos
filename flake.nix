{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    main-flake.url = "path:./hosts/main";
    uvipetr-flake.url = "path:./hosts/uvipetr";
  };

  outputs = { self, nixpkgs, home-manager, deploy-rs, main-flake, uvipetr-flake, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      main = main-flake.nixosConfigurations.main;
      uvipetr = uvipetr-flake.nixosConfigurations.uvipetr;
    };

    # --- 2. Define deploy-rs nodes ---
    # We map the nixosConfigurations to deploy-rs nodes.
    deploy.nodes = {
      uvipetr = {
        hostname = "192.168.1.100";
        profiles.system = {
          sshUser = "deploy";
          user = "root";
          sudo = "auto";
          magicRollback = true;
          path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.uvipetr;
        };
      };
    };

    checks = builtins.mapAttrs 
      (system: deployLib: deployLib.deployChecks self.deploy) 
      deploy-rs.lib;
  };
}
