{ lib, fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  pname = "finalfantasyxiv";
  version = "1.0.5";

  src = fetchurl {
    url = "https://mac-dl.ffxiv.com/cw/finalfantasyxiv-${version}.zip";
    hash = "sha256-BZEDYRuBu9GwOmIgznoajQ50uGA/Y/GaX4xy1somzZE=";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/Applications
    cp -R ../*.app $out/Applications
  '';

  meta = {
    description = ''
      Become the Warrior of Light, and fight to deliver the realm from destruction.
    '';
    homepage = "https://www.finalfantasyxiv.com";
    changelog = "https://na.finalfantasyxiv.com/lodestone/special/patchnote_log/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-darwin" ];
  };
}

