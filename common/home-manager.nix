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
      inherit (lib) mkMerge optional;
      inherit (lib.trivial) pathExists pipe;

      userDir = ./users/${name}/home-manager.nix;
      hostDir = host + /users/${name}/home-manager.nix;
      platformDir = ./${platform}/home-manager;
      systemDir = ./${platform}/${arch}/home-manager;
      
      dirs =
           optional (pathExists userDir) userDir
        ++ optional (pathExists hostDir) hostDir
        ++ optional (pathExists platformDir) platformDir
        ++ optional (pathExists systemDir) systemDir;
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
