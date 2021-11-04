{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./systemd-networkd
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "khloe";

  nix.automaticUpgrades.enable = true;

  time.timeZone = "America/New_York";

  system.stateVersion = "21.05";
}
