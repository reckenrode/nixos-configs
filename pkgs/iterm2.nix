{ lib, fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  pname = "iterm2";
  version = "3.4.8";

  src = let
    filename = "iTerm2-${lib.replaceChars ["."] ["_"] version}.zip";
  in fetchurl {
    url = "https://iterm2.com/downloads/stable/${filename}";
    hash = "sha256-KeHPgN/zzWPiPkLXgZaddKf+06revHVtAAGULkC7N28=";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';

  meta = with lib; {
    description = "A replacement for Terminal and the successor to iTerm";
    homepage = "https://www.iterm2.com/";
    license = licenses.gpl2;
    platforms = platforms.darwin;
  };
}

