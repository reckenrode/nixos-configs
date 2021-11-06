{ lib, pkgs, unstablePkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./kernel.nix
    ./systemd-networkd
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "khloe";

  nix.automaticUpgrades.enable = true;

  time.timeZone = "America/New_York";

  system.stateVersion = "21.05";
}
