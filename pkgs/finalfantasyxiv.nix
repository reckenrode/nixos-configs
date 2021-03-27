{ lib, fetchurl, stdenv, undmg }:

stdenv.mkDerivation rec {
  pname = "finalfantasyxiv";
  version = "5.45";

  src = fetchurl {
    url = "https://gdl.square-enix.com/ffxiv/inst/pnvdkzgk77dj10/FINAL_FANTASY_XIV_ONLINE_x64.dmg";
    sha256 = "oYdBTgoKEBuZXwhwbRvTQZkiWOctU1QJ8RNtqu1BPxc=";
  };

  nativeBuildInputs = [ undmg ];

  unpackPhase = ''
    undmg $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';

  meta = with lib; {
    description = ''
      Become the Warrior of Light, and fight to deliver the realm from destruction.
    '';
    homepage = "https://www.finalfantasyxiv.com";
    changelog = "https://na.finalfantasyxiv.com/lodestone/special/patchnote_log/";
    license = licenses.unfree;
    platforms = [ "x86_64-darwin" ];
  };
}

