{ config, lib, pkgs, flake, hostPath, specialArgs, ... }:

let
  inherit (flake.lib) readDirNames;

  inherit (builtins) elemAt;
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
      inherit (builtins) filter;
      inherit (lib) mkMerge;
      inherit (lib.trivial) pathExists pipe;

      srcPaths = [
        ./users/${name}
        (hostPath + /users/${name})
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
  home-manager.extraSpecialArgs = specialArgs;
}
