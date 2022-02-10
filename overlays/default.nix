{ lib }:

final: prev:
let
  inherit (builtins) listToAttrs pathExists;
  inherit (prev.lib.trivial) pipe;

  platform = prev.hostPlatform.parsed.kernel.name;
  overlays = lib.readDirNames ./${platform};
in
if pathExists ./${platform}
then
  pipe overlays [
    (map (pkg: { name = pkg; value = import ./${platform}/${pkg} final prev; }))
    listToAttrs
  ]
else { }
