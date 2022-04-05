{ ... }:

{
  targets.darwin.defaults.NSGlobalDomain = {
    AppleFontSmoothing = 0;
    AppleShowScrollBars = "Always";
    AppleReduceDesktopTinting = true;
    CGDisableCursorLocationMagnification = true;
    NSAlertMetricsGatheringEnabled = false;
  };

  targets.darwin.defaults."com.apple.universalaccess" = {
    showWindowTitlebarIcons = true;
  };
}
