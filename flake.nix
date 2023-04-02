# SPDX-License-Identifier: MIT

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-packages.url = "github:reckenrode/nix-packages";
    nix-packages.inputs.nixpkgs.follows = "nixpkgs";

    nix-unstable-packages.url = "github:reckenrode/nix-packages";
    nix-unstable-packages.inputs.nixpkgs.follows = "nixpkgs-unstable";

    verify-archive.url = "github:reckenrode/verify-archive/releases";
    verify-archive.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-darwin, home-manager, sops-nix, ... }@inputs:
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

        imac = nix-darwin.lib.darwinSystem {
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

      homeModules = {
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
