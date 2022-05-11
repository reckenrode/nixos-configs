{ lib, channels }:

let
  inherit (builtins) fromJSON listToAttrs readFile;
  inherit (channels.nixpkgs.lib.trivial) pipe;

  flakePkgs = lib.readDirNames ./.;
  unstablePkgs = pipe ./unstable-packages.json [
    readFile
    fromJSON
    (map (attr: { name = attr; value = attr; }))
    listToAttrs
  ];
in
pipe flakePkgs [
  (map (pkg:
    if unstablePkgs ? "${pkg}"
    then { name = pkg; value = channels.nixpkgs-unstable.callPackage ./${pkg} {}; }
    else { name = pkg; value = channels.nixpkgs.callPackage ./${pkg} {}; }))
  listToAttrs
]
