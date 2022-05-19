{ lib
, stdenvNoCC
, fetchurl
, unzip
, wine64Packages
}:

stdenvNoCC.mkDerivation rec {
  pname = "ffxiv";
  version = "1.0.7";

  # The Windows installer is a 32-bit app, which won’t run on Darwin because WoW64 is not yet
  # supported there with upstream Wine. The Mac client also has Bink-encoded video files that are
  # needed because the WMV-encoded ones in the Windows client don’t work with Wine by default.
  # the 1.0.5 version was pulled off Square Enix CDN and replaced with the unreleased 1.0.7 version for macOS.
  src = fetchurl {
    url = "https://mac-dl.ffxiv.com/cw/finalfantasyxiv-${version}.zip";
    hash = "sha256-a20525cce87222e6a9bbd9fe1f818a3aca1a70387ab466f95ccd38916b97b69e";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/bin
    bootstrap_path='Contents/SharedSupport/finalfantasyxiv/support/published_Final_Fantasy/drive_c/Program Files (x86)/SquareEnix/FINAL FANTASY XIV - A Realm Reborn'
    cp -Rv "$bootstrap_path/boot" "$bootstrap_path/game" $out
    rm -v $out/boot/ffxiv_dx11.dxvk-cache-base
  '';

  meta = {
    description = "FINAL FANTASY is a registered trademark of Square Enix Holdings Co., Ltd.";
    homepage = "https://www.finalfantasyxiv.com";
    changelog = "https://na.finalfantasyxiv.com/lodestone/special/patchnote_log/";
    maintainers = [ lib.maintainers.reckenrode ];
    license = lib.licenses.unfree;
    inherit (wine64Packages.unstable.meta) platforms;
    hydraPlatforms = [ ];
  };
}
