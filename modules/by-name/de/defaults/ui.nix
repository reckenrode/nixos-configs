# SPDX-License-Identifier: MIT

{ lib, pkgs, ... }:

{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    targets.darwin.defaults.NSGlobalDomain = {
      AppleFontSmoothing = 0;
      AppleShowScrollBars = "Always";
      AppleReduceDesktopTinting = true;
      CGDisableCursorLocationMagnification = true;
      # NSAlertMetricsGatheringEnabled = false;
    };

    targets.darwin.defaults."com.apple.universalaccess" = {
      showWindowTitlebarIcons = true;
    };

    targets.darwin.defaults."com.apple.WindowManager" = {
      EnableStandardClickToShowDesktop = false;
    };
  };
}
