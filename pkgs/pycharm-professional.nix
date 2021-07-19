{ lib, fetchurl, stdenv, undmg, system }:

let
  arches = {
    aarch64-darwin = {
      suffix = "-aarch64";
      hash = "sha256-SbMp+N60GvonxdcWs2cYu5dSppo8W02UU5McbAnI0lM=";
    };
    x86_64-darwin = {
      suffix = "";
      hash = "sha256-rrws3rHZw4knshj+nZaCIDb8+cZ73C88HGchShVbL+U=";
    };
  };
  arch = arches.${system};
in stdenv.mkDerivation rec {
  pname = "pycharm-professional";
  version = "2021.1.3";

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
    platforms = platforms.darwin;
  };
}
