{ ... }:

{
  networking.hostName = "iMac";
  security.pam.enableSudoTouchIdAuth= true;
  system.homePrinterFixup = true;
  programs.zsh.enable = true;
}
