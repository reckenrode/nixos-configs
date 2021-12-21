{ lib, fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  pname = "crossover";
  version = "21.1.0";

  src = fetchurl {
    url = "https://media.codeweavers.com/pub/crossover/cxmac/demo/crossover-${version}.zip";
    hash = "sha256-PBMOLrD9PVUkhPBy3CDmZQSGmOff+wbE84kAE+/1dJw=";
  };

  icon = fetchurl {
    url = "https://media.macosicons.com/parse/files/macOSicons/2db0bb2cacd0fd3d7644ab8a89cb14cd_CrossOver.icns";
    hash = "sha256-e/tFudvMO0igTfgwN81kAwicLiGliUdCFEqr/AljZnc=";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/Applications
    cp -R ../*.app $out/Applications
    rm -rf "$out/Applications/CrossOver.app/Contents/Resources/CrossOver CD Helper.app"
    cp ${icon} $out/Applications/CrossOver.app/Contents/Resources/CrossOver.icns
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

