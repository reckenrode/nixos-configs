prev:

let
  inherit (prev) lib stdenv;
in
prev.kitty.overrideAttrs (old: {
  NIX_CFLAGS_COMPILE = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) "-Wno-deprecated-declarations";
})
