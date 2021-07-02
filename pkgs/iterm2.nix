{ lib, fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  pname = "iterm2";
  version = "3.4.8";

  src = fetchurl {
    url = "https://github.com/gnachman/iTerm2/archive/refs/tags/${version}.zip"
    hash = "sha256-6u81KbweAgJEuyCnJbdG+7RNvCVr4YjVDVAiWttnax0=";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';

  meta = with lib; {
    description = "A replacement for Terminal and the successor to iTerm";
    homepage = "https://www.iterm2.com/";
    license = licenses.gpl2;
    platforms = platforms.darwin;
  };
}

