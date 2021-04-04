{ lib, fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  pname = "netnewswire";
  version = "6.0.1";

  src = fetchurl {
    url = "https://github.com/Ranchero-Software/NetNewsWire/releases/download/mac-${version}/NetNewsWire${version}.zip";
    sha256 = "CxjJWiaasbHqYf5Pe3QXbIo/vDq/ieyYPgvM/Thofnk=";
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
      It’s a free and open source feed reader for macOS and iOS.

      It supports RSS, Atom, JSON Feed, and RSS-in-JSON formats.

      More info: https://ranchero.com/netnewswire/
    '';
    homepage = "https://netnewswire.com";
    changelog = "https://github.com/Ranchero-Software/NetNewsWire/releases";
    license = licenses.mit;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}

