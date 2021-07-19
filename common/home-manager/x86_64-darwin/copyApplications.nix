{ config, lib, pkgs, ... }:

{
  home.activation = {
    copyApplications = let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
    in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      appsSrc="${apps}/Applications/"
      baseDir="$HOME/Applications/Home Manager Apps"
      rsyncArgs="--archive --checksum --chmod=u-w --copy-unsafe-links --delete"
      $DRY_RUN_CMD mkdir -p "$baseDir"
      $DRY_RUN_CMD ${pkgs.rsync}/bin/rsync ''${VERBOSE_ARG:+-v} $rsyncArgs "$appsSrc" "$baseDir"
     '';
   };
 }
