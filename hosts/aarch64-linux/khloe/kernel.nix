{ lib, unstablePkgs, ... }:

{
  boot.kernelPackages = lib.mkForce unstablePkgs.linuxPackages_latest;
  boot.kernelParams = [
    "8250.nr_uarts=1"
    "console=ttyAMA0,115200"
    "console=tty1"
    "cma=128M"
  ];
}
