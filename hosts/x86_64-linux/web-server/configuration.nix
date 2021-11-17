{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./loader.nix
    ./systemd-networkd.nix
  ];

  networking.hostName = "web-server";

  nix.automaticUpgrades.enable = true;

  time.timeZone = "America/New_York";

  system.stateVersion = "21.05";
}
