{ pkgs, ... }:

let
  copyOtf = pkg: pkg.overrideAttrs (old: {
      installPhase = ''
        $DRY_RUN_CMD install -D -m 444 fonts/otf/* -t $out/share/fonts/otf
      '';
  });
in
{
  home.packages = map copyOtf [ pkgs.alegreya pkgs.alegreya-sans ];
}
