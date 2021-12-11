_: prev:

let
  derivation = { lib, fetchurl, stdenv, undmg }:
  stdenv.mkDerivation rec {
    pname = "firefox-bin";
    version = "95.0";
    lang = "en-US";

    src = fetchurl {
      name = "Firefox-${lang}-${version}.dmg";
      url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/${lang}/Firefox%20${version}.dmg";
      hash = "sha256-34+Su6pirQSnCzjXH7dbUYElD//bYIX2aY+jPM5sBwQ";
    };

    buildInputs = [ undmg ];

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

    meta = {
      description = ''
        Mozilla Firefox, free web browser (binary package)
      '';
      homepage = "https://www.mozilla.org/firefox/";
      changelog = "https://www.mozilla.org/firefox/new/";
      license = {
        free = false;
        url = "http://www.mozilla.org/en-US/foundation/trademarks/policy/";
      };
      platforms = lib.platforms.darwin;
    };
  };
in
prev.callPackage derivation {}
