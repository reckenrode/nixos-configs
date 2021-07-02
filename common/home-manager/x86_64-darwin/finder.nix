{ config, ... }:

{
  targets.darwin.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
  targets.darwin.defaults."com.apple.finder" = {
    FinderSpawnTab = false;
    FXDefaultSearchScope = "SCcf";
    FXEnableExtensionChangeWarning = false;
    FXEnableRemoveFromICloudDriveWarning = false;
    FXRemoveOldTrashItems = true;
    NewWindowTarget = "PfID";
    NewWindowTargetPath = ''
      file:///${config.home.homeDirectory}/Library/Mobile%20Documents/com~apple~CloudDocs/
    '';
    ShowHardDrivesOnDesktop = true;
    ShowMountedServersOnDesktop = true;
    WarnOnEmptyTrash = false;
  };
}
