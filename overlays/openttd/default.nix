{ lib, fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  pname = "openttd";
  version = "1.11.0";

  src = fetchurl {
    url = "https://cdn.openttd.org/openttd-releases/${version}/openttd-${version}-macos-universal.zip";
    hash = "sha256-kzFrBhgAJxuTPNExpLhQe8NU0hHiAOUAZnNrXTaiZ4Y=";
  };

  buildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';

  meta = {
    description = ''Open source clone of the Microprose game "Transport Tycoon Deluxe"'';
    longDescription = ''
      OpenTTD is a transportation economics simulator. In single player mode,
      players control a transportation business, and use rail, road, sea, and air
      transport to move goods and people around the simulated world.

      In multiplayer networked mode, players may:
        - play competitively as different businesses
        - play cooperatively controlling the same business
        - observe as spectators
    '';
    homepage = "https://www.openttd.org/";
    changelog = "https://cdn.openttd.org/openttd-releases/${version}/changelog.txt";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.darwin;
  };
}
