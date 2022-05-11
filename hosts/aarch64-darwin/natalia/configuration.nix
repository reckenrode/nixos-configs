{ flakePkgs
, ...
}:

{
  imports = [
    ./secretive.nix
  ];

  networking.hostName = "natalia";

  environment.systemPackages = [
    flakePkgs.secretive
  ];

  security.pam.enableSudoTouchIdAuth = true;
  system.homePrinterFixup = true;
}
