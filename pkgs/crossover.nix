{ lib, fetchurl, stdenv, unzip, crossover-icon ? null }:

stdenv.mkDerivation rec {
  pname = "crossover";
  version = "21.0.0";

  src = fetchurl {
    url = "https://media.codeweavers.com/pub/crossover/cxmac/demo/crossover-${version}.zip";
    hash = "sha256-1cfXLBmJQEZ/+1P8iGhPB5alp18lBRJS2Xno3FfuJMI=";
  };

  nativeBuildInputs = [ unzip ];

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

  meta = with lib; {
    description = ''
      Steam is the ultimate destination for playing, discussing, and creating games.
    '';
    homepage = "https://www.codeweavers.com/crossover";
    license = licenses.unfree;
    platforms = [ "x86_64-darwin" ];
  };
}

