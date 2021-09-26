{ config, lib, pkgs, host, extraSpecialArgs, ... }:

let
  inherit (import ../lib) readDirNames;

  inherit (builtins) elemAt;
  inherit (lib.strings) splitString;
  inherit (pkgs) system;

  platformTuple = splitString "-" system;
  arch = elemAt platformTuple 0;
  platform = elemAt platformTuple 1;

  mkUsers = host:
    let
      inherit (builtins) listToAttrs map;

      usersPath = host + /users;
      users = readDirNames usersPath;
    in
    listToAttrs (map (mkUser host) users);

  mkUser = host: name:
    let
      inherit (builtins) filter;
      inherit (lib) mkMerge;
      inherit (lib.trivial) pathExists pipe;

      srcPaths = [
        ./users/${name}
        (host + /users/${name})
        ./${platform}
        ./${platform}/${arch}
      ];

      homeManagerPaths = map (path: path + /home-manager) srcPaths;
      
      dirs = filter pathExists homeManagerPaths;

      userModule = pipe dirs [ (map import) mkMerge ];
    in {
      inherit name;
      value = userModule;
    };
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users = mkUsers host;
  home-manager.extraSpecialArgs = extraSpecialArgs;
}
