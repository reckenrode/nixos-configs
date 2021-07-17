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
      fontSrc="${fonts}/share/fonts/otf/"
      fontDir="$HOME/Library/Fonts/Home Manager Fonts"
      rsyncArgs="--archive --chmod=u-w --delete -cL"
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir -p "$fontDir"
      $DRY_RUN_CMD ${pkgs.rsync}/bin/rsync ''${VERBOSE_ARG:+-v} $rsyncArgs "$fontSrc" "$fontDir"
    '';
  };
}
