final: prev:

let
  inherit (prev) stdenv;
in
if stdenv.isDarwin
then
{
    firefox-bin = prev.callPackage ./firefox-bin {};
    kitty = import ./kitty prev;
    openra = prev.callPackage ./openra {};
    openttd = prev.callPackage ./openttd {};
    pngout = import ./pngout prev;
    steam = prev.callPackage ./steam {};
    tesseract4 = prev.tesseract4.override {
      tesseractBase = import ./tesseract4 prev;
    };
    tiled = prev.callPackage ./tiled {};
}
else {}
