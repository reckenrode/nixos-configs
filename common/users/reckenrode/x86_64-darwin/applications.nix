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
      baseDir="$HOME/Applications/Home Manager Apps"
      rsyncArgs="--archive --chmod=u+w --delete -L"
      mkdir -p "$baseDir"
      $DRY_RUN_CMD ${pkgs.rsync}/bin/rsync $rsyncArgs ${apps}/Applications/ "$baseDir"
    '';
  };
}
