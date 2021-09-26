{ pkgs, ... }:

{
  imports = [
    ./automatic-upgrades.nix
    ./firewall.nix
    ./nix-optimizations.nix
    ./sshd.nix
    ./systemd-networkd.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  users.mutableUsers = false;

  zramSwap.enable = true;
}
