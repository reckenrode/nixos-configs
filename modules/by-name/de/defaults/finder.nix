# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
  home = config.home.homeDirectory;
in
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    targets.darwin.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
    targets.darwin.defaults."com.apple.finder" = {
      FinderSpawnTab = false;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      FXEnableRemoveFromICloudDriveWarning = false;
      FXRemoveOldTrashItems = true;
      NewWindowTarget = "PfID";
      NewWindowTargetPath = "file:///${home}/Library/Mobile%20Documents/com~apple~CloudDocs/";
      ShowHardDrivesOnDesktop = true;
      ShowMountedServersOnDesktop = true;
      WarnOnEmptyTrash = false;
    };
  };
}
