{ ... }:

{
  imports = [
    ./keybase.nix
    ./secretive.nix
  ];

  networking.hostName = "natalia";

  system.homePrinterFixup = true;
}
