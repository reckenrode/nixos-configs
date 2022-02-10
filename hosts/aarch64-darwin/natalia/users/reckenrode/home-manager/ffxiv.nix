{ config, lib, pkgs, x86_64, ... }:

let
  ffxivPath = "${config.home.homeDirectory}/Library/Application Support/FINAL FANTASY XIV ONLINE";
  bottlePath = "Bottles/published_Final_Fantasy";
  userPath = "drive_c/users/crossover";
  docsPath = "${ffxivPath}/${bottlePath}/${userPath}/My Documents/My Games";
  targetPath = "${docsPath}/FINAL FANTASY XIV - A Realm Reborn";
  settingsPath = "${ffxivPath}/Settings";
in
{
  home.activation = {
    setUpFinalFantasyXIV =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p ''${VERBOSE_ARG:+-v} "${settingsPath}"
        $DRY_RUN_CMD mkdir -p ''${VERBOSE_ARG:+-v} "${docsPath}"
        $DRY_RUN_CMD ln -sfn ''${VERBOSE_ARG:+-v} "${settingsPath}" "${targetPath}"
      '';
  };
  home.packages = [ x86_64.flakePkgs.finalfantasyxiv ];
}
