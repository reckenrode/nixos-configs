{ lib, unstablePkgs, ... }:

{
  boot.kernelPackages = lib.mkForce (unstablePkgs.linuxPackages_latest // {
    kernel = unstablePkgs.linuxPackages_latest.kernel.overrideAttrs (_: {
      extraConfig = "RESET_RASPBERRYPI y";
    });
  });
}
