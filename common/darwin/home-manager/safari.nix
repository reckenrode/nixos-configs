{ ... }:

{
  targets.darwin.defaults."com.apple.Safari" = {
    AutoFillCreditCardData = false;
    AutoFillFromAddressBook = false;
    AutoFillMiscellaneousForms = false;
    AutoFillPasswords = false;
    AutoOpenSafeDownloads = false;
    IncludeDevelopMenu = true;
    SearchProviderIdentifier = "com.duckduckgo";
    ShowOverlayStatusBar = true;
  };
}
