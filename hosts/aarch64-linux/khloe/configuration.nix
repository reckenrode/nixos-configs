{ lib, pkgs, unstablePkgs, ... }:

{
  imports = [
    ./caddy
    ./hardware-configuration.nix
    ./letsencrypt.nix
    ./loader.nix
    ./systemd-networkd.nix
  ];

  # FIXME: Once 21.11 is out, this should be able to use the default (stable) kernel
  boot.kernelPackages = lib.mkForce unstablePkgs.linuxPackages_latest;

  networking.hostName = "khloe";

  nix.automaticUpgrades.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;

  time.timeZone = "America/New_York";

  system.stateVersion = "21.05";
}
