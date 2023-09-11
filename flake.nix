# SPDX-License-Identifier: MIT

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
#    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "/Users/reckenrode/Developer/nixpkgs?ref=nixos-configs-testing";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-packages.url = "github:reckenrode/nix-packages";
    nix-packages.inputs.nixpkgs.follows = "nixpkgs";

    nix-unstable-packages.url = "github:reckenrode/nix-packages";
    nix-unstable-packages.inputs.nixpkgs.follows = "nixpkgs-unstable";

    foundryvtt.url = "github:reckenrode/nix-foundryvtt?ref=foundry-update";

    verify-archive.url = "github:reckenrode/verify-archive/releases";
    verify-archive.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-darwin, home-manager, home-manager-unstable, foundryvtt, sops-nix, ... }@inputs:
    let
      modules = import ./modules/top-level/all-modules.nix { inherit (nixpkgs) lib; };
    in
    {
      darwinConfigurations = {
        natalia = nix-darwin.lib.darwinSystem {
          inherit inputs;
          system = "aarch64-darwin";
          modules = [
            ./hosts/natalia/configuration.nix
            home-manager.darwinModules.home-manager
          ] ++ modules.darwin;
        };

        iMac = nix-darwin.lib.darwinSystem {
          inherit inputs;
          system = "x86_64-darwin";
          modules = [
            ./hosts/imac/configuration.nix
            home-manager.darwinModules.home-manager
          ] ++ modules.darwin;
        };
      };

      nixosConfigurations = {
        meteion = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/meteion/configuration.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            { _module.args = { inherit inputs; }; }
          ] ++ modules.nixos;
        };

        vamp = nixpkgs-unstable.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./hosts/vamp/configuration.nix
            home-manager-unstable.nixosModules.home-manager
            sops-nix.nixosModules.sops
            { _module.args = { inherit inputs; }; }
          ] ++ modules.nixos;
        };

        web-server = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/web-server/configuration.nix
            home-manager.nixosModules.home-manager
            foundryvtt.nixosModules.foundryvtt
            sops-nix.nixosModules.sops
            { _module.args = { inherit inputs; }; }
          ] ++ modules.nixos;
        };

        zhloe = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/zhloe/configuration.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            { _module.args = { inherit inputs; }; }
          ] ++ modules.nixos;
        };
      };

      hmModules = {
        reckenrode = {
          imports = [ ./home-manager/reckenrode/home.nix ] ++ modules.home;
          _module.args = { inherit inputs; };
        };
        server-admin = {
          imports = [ ./home-manager/server-admin/home.nix ] ++ modules.home;
          _module.args = { inherit inputs; };
        };
      };
    };
}
