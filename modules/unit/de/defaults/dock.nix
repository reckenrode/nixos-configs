# SPDX-License-Identifier: MIT

{ lib, pkgs, ... }:

{
  config = lib.mkIf pkgs.stdenv.isDarwin {
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

    targets.darwin.defaults."com.apple.controlcenter" = {
      "NSStatusItem Visible Battery" = true;
      "NSStatusItem Visible BentoBox" = true;
      "NSStatusItem Visible Clock" = true;
      "NSStatusItem Visible DoNotDisturb" = false;
      "NSStatusItem Visible Item-0" = false;
      "NSStatusItem Visible Item-1" = false;
      "NSStatusItem Visible Item-2" = false;
      "NSStatusItem Visible Item-3" = false;
      "NSStatusItem Visible Item-4" = false;
      "NSStatusItem Visible Item-5" = false;
      "NSStatusItem Visible NowPlaying" = false;
      "NSStatusItem Visible Sound" = false;
      "NSStatusItem Visible WiFi" = false;
    };
  };
}
