# SPDX-License-Identifier: MIT

{ lib, pkgs, ... }:

{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    targets.darwin.defaults.NSGlobalDomain = {
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticTextCompletionEnabled = false;
      NSUserQuotesArray = [ ''"'' ''"'' "'" "'" ];
      WebAutomaticSpellingCorrectionEnabled = false;
      "com.apple.keyboard.fnState" = 1;
    };
  };
}
