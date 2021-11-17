{ lib, pkgs, unstablePkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./loader.nix
    ./systemd-networkd
  ];

  # FIXME: Once 21.11 is out, this should be able to use the default (stable) kernel
  boot.kernelPackages = lib.mkForce unstablePkgs.linuxPackages_latest;

  networking.hostName = "khloe";

  nix.automaticUpgrades.enable = true;

  time.timeZone = "America/New_York";

  system.stateVersion = "21.05";
}
