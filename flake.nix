{
  # FIXME: macOS 11 has poor compatability with 20.09. It works if you can get packages from
  # the binary cache, but it breaks as soon as you need to compile anything.  Revert this
  # change once 21.05 is released.
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-20.09";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    foundryvtt.url = "github:reckenrode/nix-foundryvtt";
    foundryvtt.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, foundryvtt, ... }:
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

          mkHomeManagerConfig = host: mkConfiguration (mkUser host) true;

          mkHostConfig = mkConfiguration mkHost;

          mkHost = name:
            let
              homeManagerModules = if stdenv.isDarwin
                then inputs.home-manager-unstable.darwinModules.home-manager
                else home-manager.nixosModules.home-manager;

              nixSystem = if stdenv.isDarwin
                then darwin.lib.darwinSystem
                else nixpkgs.lib.nixosSystem;

            in {
              inherit name;
              value = nixSystem ({
                modules = [
                  (./hosts + "/${system}/${name}" + /configuration.nix)
                  homeManagerModules {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users = mkHomeManagerConfig name users;
                  }
                  {
                    nixpkgs.overlays = [
                      (_: _: { unstable = inputs.nixpkgs-unstable.legacyPackages.${system}; })
                    ];
                  }
                ] ++ lib.optionals stdenv.isLinux [
                  inputs.foundryvtt.nixosModules.foundryvtt
                  inputs.sops-nix.nixosModules.sops
                ];
              } // lib.optionalAttrs stdenv.isLinux { inherit system; });
            };

          mkUser = host: name:
            let
              systemDir = ./common/users + "/${name}/${system}";
              hostDir = ./common/users + "/${name}/${host}";
              userDirs = [
                (./common/users + "/${name}")
              ] ++ lib.optional (lib.trivial.pathExists systemDir) systemDir
                ++ lib.optional (lib.trivial.pathExists hostDir) hostDir;
              userModule = lib.trivial.pipe userDirs [
                (map import)
                lib.mkMerge
              ];
            in {
              inherit name;
              value = userModule;
            };

        in {
          darwinConfigurations = mkHostConfig stdenv.isDarwin hosts;
          nixosConfigurations = mkHostConfig stdenv.isLinux hosts;
        }))
      (builtins.foldl' lib.recursiveUpdate {})
    ];
}
