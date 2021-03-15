{ config, lib, pkgs, ... }:

{
  home.activation = {
    installFonts = let
      fonts = pkgs.buildEnv {
        name = "home-manager-fonts";
        paths = with pkgs; [ alegreya alegreya-sans ];
        pathsToLink = "/share/fonts/otf";
      };
    in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      fontDir="$HOME/Library/Fonts/Home Manager Fonts"
      if [ -d "$fontDir" ]; then
        rm -rf "$fontDir"
      fi
      mkdir -p "$fontDir"
      for font in ${fonts}/share/fonts/otf/*; do
        $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$font" "$fontDir"
      done
    '';
  };
}
