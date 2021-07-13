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
      rsyncArgs="--archive --chmod=u-w --delete -cL"
      ${pkgs.coreutils}/bin/mkdir -p "$baseDir"
      $DRY_RUN_CMD ${pkgs.findutils}/bin/find "$appsSrc" -maxdepth 1 -print0 | \
        ${pkgs.findutils}/bin/xargs -0 -n1 -P0 -I% \
        ${pkgs.rsync}/bin/rsync ''${VERBOSE_ARG:+-v} $rsyncArgs % "$baseDir"
    '';
  };
}
