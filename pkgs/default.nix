{ lib, channels }:

let
  inherit (builtins) listToAttrs;
  inherit (channels.nixpkgs.lib.trivial) pipe;

  flakePkgs = lib.readDirNames ./.;
in
pipe flakePkgs [
  (map (pkg: { name = pkg; value = channels.nixpkgs.callPackage ./${pkg} {}; }))
  listToAttrs
]
