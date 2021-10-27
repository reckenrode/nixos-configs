{ lib, fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  pname = "Tiled";
  version = "1.5.0";

  src = fetchurl {
    url = "https://github.com/mapeditor/tiled/releases/download/v${version}/Tiled-${version}-macos.zip";
    hash = "sha256-6w12RP3H9rVn9ALIT6eUc11xTvdcQNYjVz5n4PmkRe0=";
  };

  buildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';

  meta = with lib; {
    description = ''
      Tiled is a general purpose tile map editor for all tile-based games, such as RPGs, platformers
      or Breakout clones.
    '';
    longdescription = ''
      Tiled is highly flexible. It can be used to create maps of any size, with no restrictions on
      tile size, or the number of layers or tiles that can be used. Maps, layers, tiles, and objects
      can all be assigned arbitrary properties. Tiled's map format (TMX) is easy to understand and
      allows multiple tilesets to be used in any map. Tilesets can be modified at any time.
    '';
    homepage = "https://www.mapeditor.org";
    changelog = "https://github.com/mapeditor/tiled/releases";
    license = licenses.gpl2;
    platforms = [ "x86_64-darwin" ];
  };
}

