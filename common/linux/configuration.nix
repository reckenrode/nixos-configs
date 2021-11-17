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

  users.defaultUserShell = pkgs.fish;
  users.mutableUsers = false;

  zramSwap = {
    enable = true;
    memoryMax = 8 * 1024 * 1024 * 1024;
    memoryPercent = 100;
  };
}
