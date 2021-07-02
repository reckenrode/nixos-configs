{ ... }:

{
  targets.darwin.defaults.NSGlobalDomain = {
    AppleActionOnDoubleClick = "Minimize";
  };

  targets.darwin.defaults."com.apple.dock" = {
    "mru-spaces" = false;
    "show-recents" = false;
  };

  targets.darwin.defaults."com.apple.menuextra.clock" = {
    DateFormat = "EEE h:mm a";
    ShowDayOfMonth = false;
  };

# These don’t seem to work.
#  targets.darwin.defaults."com.apple.controlcenter" = {
#    "NSStatusItem Visible WiFi" = false;
#  };
#
#  targets.darwin.defaults."com.apple.Spotlight" = {
#    "NSStatusItem Visible Item-0" = false;
#  };
}
