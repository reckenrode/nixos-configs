{ lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./loader.nix
    ./iwd.nix
    ./samba
    ./systemd-networkd.nix
    ./zfs.nix
  ];

  # The latest Linux kernel version officially supported by ZFS.
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_5_19;

  networking.hostName = "meteion";
  networking.hostId = "41b9e6d1";

  nix.automaticUpgrades.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;

  time.timeZone = "America/New_York";

  system.stateVersion = "22.05";
}
