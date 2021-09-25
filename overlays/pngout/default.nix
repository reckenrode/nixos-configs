prev:
  prev.pngout.overrideAttrs (_: rec {
    name = "pngout-20200115";
    src = builtins.fetchurl {
      url = "http://www.jonof.id.au/files/kenutils/pngout-20200115-macos.zip";
      sha256 = "sha256-MnL6lH7q/BrACG4fFJNfnvoh0JClVeaJIlX+XIj2aG4=";
    };
    nativeBuildInputs = [ prev.unzip ];
    unpackPhase = ''
      unzip "$src"
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp ${name}-macos/pngout $out/bin
      /usr/bin/codesign -fs - $out/bin/pngout
    '';
  })
