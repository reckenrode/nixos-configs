prev:

let
  inherit (prev) lib stdenv;
  inherit (prev.tesseract4) tesseractBase;
in
tesseractBase.overrideAttrs (old: lib.optionalAttrs (stdenv.isDarwin && stdenv.isAarch64) {
  # Fix build error on aarch64-darwin due to the presence of `VERSION` in the root of the repo.
  postConfigure = "rm VERSION";
})
