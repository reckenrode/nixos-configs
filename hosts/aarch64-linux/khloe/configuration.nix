{ lib, pkgs, unstablePkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./kernel.nix
    ./systemd-networkd
  ];

  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "khloe";

  nix.automaticUpgrades.enable = true;

  time.timeZone = "America/New_York";

  system.stateVersion = "21.05";
}
