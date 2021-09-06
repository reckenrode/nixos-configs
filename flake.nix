{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    verify-archive.url = "github:reckenrode/verify-archive";
    verify-archive.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }:
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
          pkgs = nixpkgs.legacyPackages.${system};
          stdenv = pkgs.stdenv;

          hosts = readDirNames (./hosts + "/${system}");
          users = host: readDirNames ((hostPath host) + /users);

          hostPath = host: ./hosts + "/${system}/${host}";
          userPath = user: host: (hostPath host) + /users + "/${user}";

          mkConfiguration = f: pred: lst:
            lib.optionalAttrs pred (builtins.listToAttrs (map f lst));

          mkHomeManagerConfig = host: mkConfiguration (mkUser host) true;

          mkHostConfig = mkConfiguration mkHost;

          mkHost = name:
            let
              homeManagerModules = if stdenv.isDarwin
                then home-manager.darwinModules.home-manager
                else home-manager.nixosModules.home-manager;

              nixSystem = if stdenv.isDarwin
                then darwin.lib.darwinSystem
                else nixpkgs.lib.nixosSystem;

              hostUsers = users name;
              userConfigs = [ ./common/users/reckenrode ];

            in {
              inherit name;
              value = nixSystem ({
                modules = userConfigs ++ [
                  ((hostPath name) + /configuration.nix)
                  homeManagerModules {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users = mkHomeManagerConfig name hostUsers;
                  }
                  {
                    nixpkgs.overlays = [
                      (_: _: { unstable = inputs.nixpkgs-unstable.legacyPackages.${system}; })
                      (_: _: {
                        verify-archive = inputs.verify-archive.packages.${system}.verify-archive;
                      })
                    ];
                  }
                ] ++ lib.optionals stdenv.isLinux [
                  inputs.sops-nix.nixosModules.sops
                ];
              } // lib.optionalAttrs stdenv.isLinux { inherit system; });
            };

          mkUser = host: name:
            let
              hostDir = (hostPath host) + /users + "/${name}";
              systemDir = ./common/home-manager + "/${system}";
              userDirs = [
                (./common/users + "/${name}" + /home-manager.nix)
              ] ++ lib.optional (lib.trivial.pathExists hostDir) hostDir
                ++ lib.optional (lib.trivial.pathExists systemDir) systemDir;
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
