{ lib, pkgs, unstablePkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./systemd-networkd
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = lib.mkForce unstablePkgs.linuxPackages_latest;

  networking.hostName = "khloe";

  nix.automaticUpgrades.enable = true;

  time.timeZone = "America/New_York";

  system.stateVersion = "21.05";
}
