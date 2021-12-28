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
    url = "https://github.com/marzent/dxvk/releases/download/v1.9.2-mac-async/dxvk-1.9.2-mac-async.zip";
    hash = "sha256-2vOVR4b1ek1UdGRlIIGBLQd9XUqZLyVrxBnaufutfFg=";
  };

  moltenvk = fetchurl {
    url = "https://github.com/Gcenx/MoltenVK/releases/download/v1.1.6/macos_dxvk_patched-1.1.6_2.tar.xz";
    hash = "sha256-XwGEK/3AEKgo+LiRS2GTZNFlZsj+uudT2zZoEReMShU=";
  };

  buildInputs = [ unzip xz ];

  unpackPhase = ''
    unpackPhase
    unzip ${dxvk}
    xz -d < "${moltenvk}" | tar xf - --warning=no-timestamp
  '';

  buildPhase = ''
    install -d -m755 Contents/SharedSupport/DXVK/
    pushd ../dxvk-1.9.2-mac-async/x64/
    install -m755 \
      d3d10.dll d3d10_1.dll d3d10core.dll d3d11.dll d3d9.dll dxgi.dll \
      ../../CrossOver.app/Contents/SharedSupport/DXVK/
    popd
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
    description = ''
      CrossOver is the easiest way to run many Microsoft applications on your Mac without a clunky
      Windows emulator.
    '';
    homepage = "https://www.codeweavers.com/crossover";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-darwin" ];
  };
}

