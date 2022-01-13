{ lib, fetchurl, fetchFromGitHub, stdenv, unzip, xz }:

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

  dxvk = fetchurl {
    url = "https://github.com/marzent/dxvk/releases/download/v1.9.3-mac/dxvk-1.9.3-mac-async.tar.xz";
    hash = "sha256-onFrs0uIWHHGJWGEa1GIAKq4UMFHagejg29kEkN++/g=";
  };

  moltenvk = fetchurl {
    url = "https://github.com/Gcenx/MoltenVK/releases/download/v1.1.6/macos_dxvk_patched-1.1.6_2.tar.xz";
    hash = "sha256-XwGEK/3AEKgo+LiRS2GTZNFlZsj+uudT2zZoEReMShU=";
  };

  buildInputs = [ unzip xz ];

  unpackPhase = ''
    unpackPhase
    xz -d < "${dxvk}" | tar xf - --warning=no-timestamp
    xz -d < "${moltenvk}" | tar xf - --warning=no-timestamp
  '';

  buildPhase = ''
    install_dxvk() {
      arch=$([ "$1" = "64" ] && echo "x64" || echo "x32")
      lib=$([ "$1" = "64" ] && echo "lib64" || echo "lib")
      pushd ../dxvk-1.9.3-mac-async/$arch
      install -m755 \
        d3d10.dll d3d10_1.dll d3d10core.dll d3d11.dll d3d9.dll dxgi.dll \
        ../../CrossOver.app/Contents/SharedSupport/CrossOver/$lib/wine/dxvk
      popd
    }
    install_dxvk 32
    install_dxvk 64
    install -m755 ../Package/Release/MoltenVK/dylib/macOS/libMoltenVK.dylib \
      Contents/SharedSupport/CrossOver/lib64/
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

