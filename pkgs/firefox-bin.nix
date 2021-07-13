{ lib, fetchurl, stdenv, undmg }:

stdenv.mkDerivation rec {
  pname = "firefox-bin";
  version = "90.0";
  lang = "en-US";

  src = fetchurl {
    name = "Firefox-${lang}-${version}.dmg";
    url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/${lang}/Firefox%20${version}.dmg";
    hash = "sha256-28CAOOKiYBfTYLvzZqk1CE7Q4JFNxQ8+fkGeW3ZciGM=";
  };

  nativeBuildInputs = [ undmg ];

  unpackPhase = ''
    undmg $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';

  patchPhase = ''
    # Don't download updates from Mozilla directly
    echo 'pref("app.update.auto", "false");' >> Firefox.app/Contents/Resources/defaults/pref/channel-prefs.js
  '';

  meta = with lib; {
    description = ''
      Mozilla Firefox, free web browser (binary package)
    '';
    homepage = "https://www.mozilla.org/firefox/";
    changelog = "https://www.mozilla.org/firefox/new/";
    license = {
      free = false;
      url = "http://www.mozilla.org/en-US/foundation/trademarks/policy/";
    };
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}

