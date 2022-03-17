{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./loader.nix
    ./samba
    ./systemd-networkd.nix
    ./zfs.nix
  ];

  networking.hostName = "meteion";
  networking.hostId = "41b9e6d1";

  nix.automaticUpgrades.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;

  time.timeZone = "America/New_York";

  system.stateVersion = "21.11";
}
