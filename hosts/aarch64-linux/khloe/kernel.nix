{ lib, unstablePkgs, ... }:

{
  boot.kernelPackages = lib.mkForce unstablePkgs.linuxPackages_latest;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
}
