{ lib, fetchurl, stdenv, undmg }:

stdenv.mkDerivation rec {
  pname = "openra";
  version = "release-20210321";

  src = fetchurl {
    url = "https://github.com/OpenRA/OpenRA/releases/download/${version}/OpenRA-${version}.dmg";
    hash = "sha256-IDRgc3MePcDM/HnOBavi4eOp2BX7lFwGgxadRVxsEAQ=";
  };

  buildInputs = [ undmg ];

  unpackPhase = ''
    undmg $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';

  meta = {
    description = ''
      OpenRA is an open source project that recreates and modernizes classic real time strategy
      games, like Red Alert, Command & Conquer, and Dune 2000.
    '';
    homepage = "https://www.openra.net/";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-darwin" ];
  };
}
