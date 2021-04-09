{ lib, fetchurl, stdenv, undmg, system }:

let
  arches = {
    aarch64-darwin = {
      suffix = "-aarch64";
      hash = "sha256-VWd/PoxFs+nT+vs2njeAk98hcX0TeBfHpA8xvLOkCPs=";
    };
    x86_64-darwin = {
      suffix = "";
      hash = "sha256-VTo+Cz4R9C3vVJC/9m1mKJ5YCv2JKtV3VbOitweQCek=";
    };
  };
  arch = arches.${system};
in stdenv.mkDerivation rec {
  pname = "ruby-mine";
  version = "2021.1";

  src = fetchurl {
    url = "https://download.jetbrains.com/ruby/RubyMine-${version}${arch.suffix}.dmg";
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
      RubyMine is an integrated development environment that helps you be more productive in every
      aspect of Ruby/Rails projects development – from writing and debugging code to testing and
      deploying a completed application. This section will give you a brief overview of some of the
      most essential features available in RubyMine.
    '';
    homepage = "https://www.jetbrains.com/ruby/";
    changelog = "https://www.jetbrains.com/ruby/whatsnew/";
    license = licenses.unfree;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
