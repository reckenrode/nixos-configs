{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./kea
    ./letsencrypt.nix
    ./systemd-networkd
    ./unbound
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "zhloe";

  nix.automaticUpgrades.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;

  time.timeZone = "America/New_York";

  system.stateVersion = "21.05";
}
