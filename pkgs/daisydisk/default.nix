{ lib, fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  pname = "daisydisk";
  version = "4.21.4";

  src = fetchurl {
    url = "https://web.archive.org/web/20220125065525/https://daisydiskapp.com/downloads/DaisyDisk.zip";
    hash = "sha256-SKJjemZGTSFq+FWD4ccV7UURKZ4Iv7SXhV09dA/UwJ0=";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/Applications
    cp -R ../*.app $out/Applications
  '';

  meta = {
    description = ''
      DaisyDisk is a tool for examining disks to find out what is taking up space, and for
      recovering it.
    '';
    homepage = "https://daisydiskapp.com";
    changelog = "https://daisydiskapp.com/downloads/appcastReleaseNotes.php?appEdition=Standard";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}

