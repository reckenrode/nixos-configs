{ lib, fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  pname = "netnewswire";
  version = "6.0.2";

  src = fetchurl {
    url = "https://github.com/Ranchero-Software/NetNewsWire/releases/download/mac-${version}/NetNewsWire${version}.zip";
    hash = "sha256-vz94otRVKgIqF6QRetgZUIoCW1HHnhkFvNRCMzMdHu0=";
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

