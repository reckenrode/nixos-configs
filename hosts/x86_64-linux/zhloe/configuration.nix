{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./kea
    ./letsencrypt.nix
    ./loader.nix
    ./systemd-networkd
    ./unbound
  ];

  networking.hostName = "zhloe";

  nix.automaticUpgrades.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;

  time.timeZone = "America/New_York";

  system.stateVersion = "22.05";
}
