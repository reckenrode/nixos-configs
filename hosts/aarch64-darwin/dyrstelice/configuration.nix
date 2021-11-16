{ ... }:

{
  imports = [
    ./keybase.nix
    ./secretive.nix
  ];

  networking.hostName = "dyrstelice";

  system.homePrinterFixup = true;
}
