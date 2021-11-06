{ lib, unstablePkgs, ... }:

{
  boot.kernelPackages = lib.mkForce unstablePkgs.linuxPackages_latest;
}
