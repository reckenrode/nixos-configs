{ lib
, stdenv
, requireFile
, undmg
}:

stdenv.mkDerivation rec {
  pname = "dungeondraft";
  version = "${majorVersion}.${minorVersion}.${patchVersion}+${build}";

  majorVersion = "1";
  minorVersion = "0";
  patchVersion = "2";
  build = "4";

  src = requireFile {
    name = "Dungeondraft-${majorVersion}.${minorVersion}.${patchVersion}.${build}-macOS.dmg";
    sha256 = "sha256-t3MPg7ZG6SY8QoqoWNGXuZT4UXG7fLuDUUqM19UYyIg=";
    url = "https://dungeondraft.net";
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
    description = "An intuitive mapping tool for creating world maps.";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-darwin" ];
  };
}
