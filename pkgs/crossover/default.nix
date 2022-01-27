{ lib, fetchurl, fetchFromGitHub, stdenv, unzip, xz }:

let
  dxvk.version = "1.9.3";
  moltenvk = {
    version = "1.1.6";
    build = "_2";
  };
in
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

  dxvkDist = fetchurl {
    url = "https://github.com/marzent/dxvk/releases/download/v${dxvk.version}-mac/dxvk-${dxvk.version}-mac-async.tar.xz";
    hash = "sha256-onFrs0uIWHHGJWGEa1GIAKq4UMFHagejg29kEkN++/g=";
  };

  moltenvkDist = fetchurl {
    url = "https://github.com/Gcenx/moltenvk/releases/download/v${moltenvk.version}/macos_dxvk_patched-${moltenvk.version}${moltenvk.build}.tar.xz";
    hash = "sha256-XwGEK/3AEKgo+LiRS2GTZNFlZsj+uudT2zZoEReMShU=";
  };

  buildInputs = [ unzip xz ];

  unpackPhase = ''
    unpackPhase
    xz -d < "${dxvkDist}" | tar xf - --warning=no-timestamp
    xz -d < "${moltenvkDist}" | tar xf - --warning=no-timestamp
  '';

  buildPhase = ''
    install_dxvk() {
      arch=$([ "$1" = "64" ] && echo "x64" || echo "x32")
      lib=$([ "$1" = "64" ] && echo "lib64" || echo "lib")
      pushd ../dxvk-${dxvk.version}-mac-async/$arch
      install -m755 \
        d3d10.dll d3d10_1.dll d3d10core.dll d3d11.dll d3d9.dll dxgi.dll \
        ../../CrossOver.app/Contents/SharedSupport/CrossOver/$lib/wine/dxvk
      popd
    }
    install_dxvk 32
    install_dxvk 64
    install -m755 ../Package/Release/moltenvk/dylib/macOS/libmoltenvk.dylib \
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

