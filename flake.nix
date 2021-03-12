{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-20.09";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-20.09";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager }:
    let
      lib = nixpkgs.lib;
      systems = readDirNames ./hosts;

      readDirNames = path:
        lib.trivial.pipe (builtins.readDir path) [
          (lib.filterAttrs (_: entryType: entryType == "directory"))
          (lib.attrNames)
        ];

    in lib.trivial.pipe systems [
      (map (system:
        let
          stdenv = nixpkgs.legacyPackages.${system}.stdenv;
          hosts = readDirNames (./hosts + "/${system}");
          users = readDirNames ./common/users;

          mkConfiguration = f: pred: lst:
            lib.optionalAttrs pred (builtins.listToAttrs (map f lst));

          mkHomeManagerConfig = mkConfiguration mkUser true;

          mkHostConfig = mkConfiguration mkHost;

          mkHost = name:
            let
              homeManagerModules = if stdenv.isDarwin
                then home-manager.darwinModules.home-manager
                else home-manager.nixosModules.home-manager;
              nixSystem = if stdenv.isDarwin
                then darwin.lib.darwinSystem
                else nixpkgs.lib.nixosSystem;
            in {
              inherit name;
              value = nixSystem {
                modules = [
                  (./hosts + "/${system}/${name}" + /configuration.nix)
                  homeManagerModules {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users = mkHomeManagerConfig users;
                  }
                ];
              } // lib.optionalAttrs stdenv.isLinux { inherit system; };
            };

          mkUser = name: {
            inherit name;
            value = import (./common/users + "/${name}");
          };

        in {
          darwinConfigurations = mkHostConfig stdenv.isDarwin hosts;
          nixosConfigurations = mkHostConfig stdenv.isLinux hosts;
        }))
      (builtins.foldl' lib.recursiveUpdate {})
    ];
}
