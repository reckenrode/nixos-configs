{ ... }:

{
  imports = [
    ./keybase.nix
    ./secretive.nix
  ];

  networking.hostName = "natalia";

  security.pam.enableSudoTouchIdAuth = true;
  system.homePrinterFixup = true;
}
