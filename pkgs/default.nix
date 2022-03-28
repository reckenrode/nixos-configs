{ lib, channels }:

let
  inherit (builtins) listToAttrs;
  inherit (channels.nixpkgs.lib.trivial) pipe;

  flakePkgs = lib.readDirNames ./.;
in
pipe flakePkgs [
  (map (pkg:
    if pkg == "crossover"
    then { name = pkg; value = channels.nixpkgs-unstable.callPackage ./${pkg} {}; }
    else { name = pkg; value = channels.nixpkgs.callPackage ./${pkg} {}; }))
  listToAttrs
]
