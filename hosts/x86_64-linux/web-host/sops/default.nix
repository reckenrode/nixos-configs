{ config, ... }:

{
  sops.defaultSopsFile = ./secrets.yaml;

  sops.secrets.github_token = {
    path = "/root/.ssh/id_ed25519";
    mode = "0400";
  };

  systemd.services.nixos-upgrade.serviceConfig.SupplementaryGroups = [
    config.users.groups.keys.name
  ];
}