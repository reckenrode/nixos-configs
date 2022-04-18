{ ... }:

{
  targets.darwin.defaults."com.apple.Safari" = {
    AutoFillCreditCardData = false;
    AutoFillFromAddressBook = false;
    AutoFillMiscellaneousForms = false;
    AutoFillPasswords = false;
    AutoOpenSafeDownloads = false;
    EnableNarrowTabs = true;
    IncludeDevelopMenu = true;
    NeverUseBackgroundColorInToolbar = true;
    SearchProviderIdentifier = "com.duckduckgo";
    ShowOverlayStatusBar = true;
    ShowStandaloneTabBar = true;
  };
}
