{ lib, fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  pname = "netnewswire";
  version = "6.0.3";

  src = fetchurl {
    url = "https://github.com/Ranchero-Software/NetNewsWire/releases/download/mac-${version}/NetNewsWire${version}.zip";
    hash = "sha256-0erzd23Mda0mDPoUvVuPbLO1cshKwBtUX+bM8aYJd3w=";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/Applications
    cp -R ../*.app $out/Applications
  '';

  meta = {
    description = ''
      It’s a free and open source feed reader for macOS and iOS.

      It supports RSS, Atom, JSON Feed, and RSS-in-JSON formats.

      More info: https://ranchero.com/netnewswire/
    '';
    homepage = "https://netnewswire.com";
    changelog = "https://github.com/Ranchero-Software/NetNewsWire/releases";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
  };
}

