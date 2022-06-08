{ lib
, fetchurl
, stdenv
, darwin
, dxvk
, unzip
, iUnderstandThatReplacingMoltenVKAndDXVKIsNotSupportedByCodeWeaversAndWillNotBotherThemForSupport ? false
}:

stdenv.mkDerivation rec {
  pname =
    if !iUnderstandThatReplacingMoltenVKAndDXVKIsNotSupportedByCodeWeaversAndWillNotBotherThemForSupport
    then throw "Modifying the files in CrossOver is not supported by CodeWeavers."
    else "crossover";
  version = "21.2.0";

  src = fetchurl {
    url = "https://media.codeweavers.com/pub/crossover/cxmac/demo/crossover-${version}.zip";
    hash = "sha256-lOs2O9m9ztlVSOhYki0mLKP3AVarnbo9aH6y+ii9uuA=";
  };

  icon = fetchurl {
    url = "https://media.macosicons.com/parse/files/macOSicons/2db0bb2cacd0fd3d7644ab8a89cb14cd_CrossOver.icns";
    hash = "sha256-e/tFudvMO0igTfgwN81kAwicLiGliUdCFEqr/AljZnc=";
  };

  nativeBuildInputs = [ unzip ];

  buildPhase = ''
    install_dxvk() {
      arch=$([ "$1" = "64" ] && echo "x64" || echo "x32")
      lib=$([ "$1" = "64" ] && echo "lib64" || echo "lib")
      rm -rf Contents/SharedSupport/CrossOver/$lib/wine/dxvk
      ln -s ${dxvk.bin}/$arch Contents/SharedSupport/CrossOver/$lib/wine/dxvk
    }

    install_dxvk 32
    install_dxvk 64

    rm Contents/SharedSupport/CrossOver/lib64/libMoltenVK.dylib
    ln -s ${darwin.moltenvk}/lib/libMoltenVK.dylib Contents/SharedSupport/CrossOver/lib64/libMoltenVK.dylib

    install -m644 ${icon} Contents/Resources/CrossOver.icns

    rm -rf "CrossOver.app/Contents/Resources/CrossOver CD Helper.app"
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -R ../*.app $out/Applications
  '';

  meta = {
    description = "CrossOver allows you to run Microsoft applications on your Mac.";
    homepage = "https://www.codeweavers.com/crossover";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-darwin" ];
  };
}

