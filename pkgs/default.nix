{ lib, channels }:

let
  inherit (builtins) attrNames fromJSON listToAttrs readFile;
  inherit (channels.nixpkgs.lib.trivial) pipe;

  flakePkgs = lib.readDirNames ./.;
  unstablePkgs = pipe ./unstable-packages.json [
    readFile
    fromJSON
  ];
in
pipe flakePkgs [
  (map (pkg:
    if unstablePkgs ? "${pkg}"
    then { name = pkg; value = channels.${unstablePkgs.${pkg}}.callPackage ./${pkg} {}; }
    else { name = pkg; value = channels.nixpkgs.callPackage ./${pkg} {}; }))
  listToAttrs
]
