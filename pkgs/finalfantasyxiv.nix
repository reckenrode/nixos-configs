{ lib, fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  pname = "finalfantasyxiv";
  version = "1.05";

  src = fetchurl {
    url = "https://mac-dl.ffxiv.com/cw/finalfantasyxiv-1.0.5.zip";
    hash = "sha256-BZEDYRuBu9GwOmIgznoajQ50uGA/Y/GaX4xy1somzZE=";
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
    description = ''
      Become the Warrior of Light, and fight to deliver the realm from destruction.
    '';
    homepage = "https://www.finalfantasyxiv.com";
    changelog = "https://na.finalfantasyxiv.com/lodestone/special/patchnote_log/";
    license = licenses.unfree;
    platforms = [ "x86_64-darwin" ];
  };
}

