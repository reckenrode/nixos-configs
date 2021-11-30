{ lib, fetchurl, stdenv, unzip, crossover-icon ? ./crossover.icns }:

stdenv.mkDerivation rec {
  pname = "crossover";
  version = "21.1.0";

  src = fetchurl {
    url = "https://media.codeweavers.com/pub/crossover/cxmac/demo/crossover-${version}.zip";
    hash = "sha256-PBMOLrD9PVUkhPBy3CDmZQSGmOff+wbE84kAE+/1dJw";
  };

  buildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
    rm -rf "$out/Applications/CrossOver.app/Contents/Resources/CrossOver CD Helper.app"
  '' + lib.optionalString (!isNull crossover-icon) ''
    cp ${crossover-icon} $out/Applications/CrossOver.app/Contents/Resources/CrossOver.icns
  '';

  meta = {
    description = ''
      Steam is the ultimate destination for playing, discussing, and creating games.
    '';
    homepage = "https://www.codeweavers.com/crossover";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-darwin" ];
  };
}

