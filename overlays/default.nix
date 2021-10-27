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
      tiled = prev.callPackage ./tiled {};
  }
  else {}
