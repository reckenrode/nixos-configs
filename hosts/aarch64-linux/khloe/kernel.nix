{ lib, unstablePkgs, ... }:

{
  boot.kernelPackages = lib.mkForce unstablePkgs.linuxPackages_5_14;
}
