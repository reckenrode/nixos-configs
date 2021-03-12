{ pkgs, ... }:

{
  imports = [
    ./automatic-upgrades.nix
    ./base.nix
    ./firewall.nix
    ./nix-flakes.nix
    ./nix-optimizations.nix
    ./sshd.nix
    ./systemd-networkd.nix
    ./users
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  security.sudo.wheelNeedsPassword = false;

  users.mutableUsers = false;

  zramSwap.enable = true;
}
