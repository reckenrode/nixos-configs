{ lib, fetchurl, stdenv, undmg, system }:

let
  suffixes = { aarch64-darwin = "-aarch64"; x86_64-darwin = ""; };
  suffix = suffixes.${system};
in stdenv.mkDerivation rec {
  pname = "ruby-mine";
  version = "2021.1-beta${build}";
  build = "211.6693.18";

  src = fetchurl {
    url = "https://download.jetbrains.com/ruby/RubyMine-${build}${suffix}.dmg";
    sha256 = "0K7SG01PHky6t0v7SD8p71s8ezfNzb47IdTStxqnEDo=";
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
