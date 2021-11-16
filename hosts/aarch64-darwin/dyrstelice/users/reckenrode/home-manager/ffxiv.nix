{ config, lib, pkgs, x86_64, ... }:

let
  ffxiv_path = "${config.home.homeDirectory}/Library/Application Support/FINAL FANTASY XIV ONLINE";
  bottle_path = "Bottles/published_Final_Fantasy";
  user_path = "drive_c/users/crossover";
  docs_path = "${ffxiv_path}/${bottle_path}/${user_path}/My Documents";
  settings_path = "${ffxiv_path}/Settings";
in
{
  home.activation = {
    setUpFinalFantasyXIV =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p ''${VERBOSE_ARG:+-v} "${settings_path}"
        $DRY_RUN_CMD mkdir -p ''${VERBOSE_ARG:+-v} "${docs_path}"
        $DRY_RUN_CMD ln -sfn ''${VERBOSE_ARG:+-v} "${settings_path}" "${docs_path}"
     '';
   };
  home.packages = [ x86_64.flakePkgs.finalfantasyxiv ];
}
