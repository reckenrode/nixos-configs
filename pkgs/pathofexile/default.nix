{ lib, fetchurl, stdenv, undmg }:

stdenv.mkDerivation rec {
  pname = "pathofexile";
  version = "1.0";

  src = fetchurl {
    url = "http://webcdn.pathofexile.com/public/tmp/PathOfExile-Installer.dmg";
    hash = "sha256-acpDCljSFL9uLDpfQtz+zxljfPpB2LqxlNcBkPIMYXY=";
  };

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    mkdir -p $out/Applications
    cp -R ../*.app $out/Applications
  '';

  meta = {
    description = ''
      Path of Exile is an online Action RPG set in the dark fantasy world of Wraeclast. It is
      designed around a strong online item economy, deep character customisation, competitive PvP
      and ladder races. The game is completely free and will never be “pay to win”.
    '';
    homepage = "https://www.pathofexile.com";
    changelog = "https://www.pathofexile.com/forum/view-forum/patch-notes";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-darwin" ];
  };
}

