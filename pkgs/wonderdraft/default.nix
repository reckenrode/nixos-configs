{ lib
, stdenv
, requireFile
, undmg
}:

stdenv.mkDerivation rec {
  pname = "wonderdraft";
  version = "${majorVersion}.${minorVersion}.${patchVersion}+${build}";

  majorVersion = "1";
  minorVersion = "1";
  patchVersion = "7";
  build = "3";

  src = requireFile {
    name = "Wonderdraft-${majorVersion}.${minorVersion}.${patchVersion}.${build}-macOS.dmg";
    sha256 = "sha256-uzzVocM1stS4leYGbApDvruy6H4DdnpEPY0rHjhCF/k=";
    url = "https://www.wonderdraft.net";
  };

  nativeBuildInputs = [ undmg ];

  unpackPhase = "undmg $src";

  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/Applications
    cp -R *.app $out/Applications
  '';

  meta = {
    homepage = "https://foundryvtt.com";
    description = "An intuitive mapping tool for creating dungeon maps.";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-darwin" ];
  };
}
