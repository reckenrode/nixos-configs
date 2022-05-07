{ config, lib, pkgs, flake, hostPath, specialArgs, ... }:

let
  inherit (flake.lib) readDirNames;

  inherit (builtins) elemAt removeAttrs;
  inherit (lib.strings) splitString;
  inherit (pkgs.stdenv.hostPlatform) system;

  platformTuple = splitString "-" system;
  arch = elemAt platformTuple 0;
  platform = elemAt platformTuple 1;

  mkUsers = hostPath:
    let
      inherit (builtins) listToAttrs map;

      usersPath = hostPath + /users;
      users = readDirNames usersPath;
    in
    listToAttrs (map (mkUser hostPath) users);

  mkUser = hostPath: name:
    let
      inherit (builtins) concatMap filter;
      inherit (lib) mkMerge;
      inherit (lib.trivial) pathExists pipe;

      srcPaths = [
        ./users/${name}
        ./users/${name}/${platform}
        ./users/${name}/${platform}/${arch}
        (hostPath + /users/${name})
        ./shared
        ./${platform}
        ./${platform}/${arch}
      ];

      homeManagerPaths = map (path: path + /home-manager) srcPaths;

      dirs = filter pathExists homeManagerPaths;

      userModule = pipe dirs [ (map import) mkMerge ];
    in
    {
      inherit name;
      value = userModule;
    };
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users = mkUsers hostPath;
  home-manager.extraSpecialArgs = removeAttrs specialArgs [ "modulesPath" ];
}
