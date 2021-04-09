{ lib, fetchurl, stdenv, undmg }:

stdenv.mkDerivation rec {
  pname = "steam";
  version = "v020";

  src = fetchurl {
    url = "https://cdn.cloudflare.steamstatic.com/client/installer/steam.dmg";
    hash = "sha256-2nhxNan13aOYESua7p5rYhbtdUZ8UMcPXfOXo1N2oOk=";
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
      Steam is the ultimate destination for playing, discussing, and creating games.
    '';
    homepage = "https://steampowered.com";
    license = licenses.unfree;
    platforms = [ "x86_64-darwin" ];
  };
}

