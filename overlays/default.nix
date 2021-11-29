{ lib }:

final: prev:
  let
    inherit (builtins) listToAttrs;
    inherit (prev.lib.trivial) pipe;

    platform = prev.hostPlatform.parsed.kernel.name;
    overlays = lib.readDirNames ./${platform};
  in
    pipe overlays [
      (map (pkg: { name = pkg; value = import ./${platform}/${pkg} final prev; }))
      listToAttrs
    ]
