{ pkgs, ... }:

let
  secrets = import ./secrets.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ./kea
    ./letsencrypt.nix
    ./systemd-networkd
    ./unbound
    ../../../common/unbound.nix
    ../../../common/linux.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "zhloe";

  environment.systemPackages = with pkgs; [
    neovim
    ripgrep
  ];

  nix.automaticUpgrades.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;

  time.timeZone = "America/New_York";

  system.stateVersion = "21.05";
}
