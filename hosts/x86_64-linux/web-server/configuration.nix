{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./letsencrypt.nix
    ./loader.nix
    ./systemd-networkd.nix
  ];

  networking.hostName = "web-server";

  nix.automaticUpgrades.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  time.timeZone = "America/New_York";

  system.stateVersion = "21.05";
}
