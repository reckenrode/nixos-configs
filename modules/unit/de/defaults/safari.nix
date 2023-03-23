# SPDX-License-Identifier: MIT

{ lib, pkgs, ... }:

{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    targets.darwin.defaults."com.apple.Safari" = {
      AutoFillCreditCardData = true;
      AutoFillFromAddressBook = true;
      AutoFillMiscellaneousForms = false;
      AutoFillPasswords = true;
      AutoOpenSafeDownloads = false;
      EnableNarrowTabs = true;
      IncludeDevelopMenu = true;
      NeverUseBackgroundColorInToolbar = true;
      SearchProviderIdentifier = "com.duckduckgo";
      ShowOverlayStatusBar = true;
      ShowStandaloneTabBar = true;
    };
  };
}
