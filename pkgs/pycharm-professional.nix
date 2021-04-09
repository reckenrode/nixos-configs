{ lib, fetchurl, stdenv, undmg, system }:

let
  arches = {
    aarch64-darwin = {
      suffix = "-aarch64";
      hash = "sha256-dDw3ZQ2FNEXpJ8MMks5MURhr5nwk/laOEfvckPuir4o=";
    };
    x86_64-darwin = {
      suffix = "";
      hash = "sha256-FfZXCcPjXN0iaJhh3zM2ZAk9QFyMhtJtXdRZ8FZy3E0=";
    };
  };
  arch = arches.${system};
in stdenv.mkDerivation rec {
  pname = "pycharm-professional";
  version = "2021.1";

  src = fetchurl {
    url = "https://download.jetbrains.com/python/${pname}-${version}${arch.suffix}.dmg";
    hash = arch.hash;
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
      Python IDE with complete set of tools for productive
      development with Python programming language. In addition, the
      IDE provides high-class capabilities for professional Web
      development with Django framework and Google App Engine. It
      has powerful coding assistance, navigation, a lot of
      refactoring features, tight integration with various Version
      Control Systems, Unit testing, powerful all-singing
      all-dancing Debugger and entire customization. PyCharm is
      developer driven IDE. It was developed with the aim of
      providing you almost everything you need for your comfortable
      and productive development!
    '';
    homepage = "https://www.jetbrains.com/pycharm/";
    changelog = "https://www.jetbrains.com/pycharm/whatsnew/";
    license = licenses.unfree;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
