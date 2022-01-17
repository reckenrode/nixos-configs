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
  patchVersion = "6";
  build = "1";

  src = requireFile {
    name = "Wonderdraft-${majorVersion}.${minorVersion}.${patchVersion}.${build}-macOS.dmg";
    sha256 = "sha256-wvJ9RrtdlQ2e4lBYOGfVzaCDx7wpCef4UzbGObug5cE=";
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
