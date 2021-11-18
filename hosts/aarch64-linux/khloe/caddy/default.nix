{ config, ... }:

{
  networking.nftables.ruleset = builtins.readFile ./caddy.nft;
  
  services.caddy = {
    enable = true;
    config = builtins.readFile ./Caddyfile;
  };

  systemd.services.caddy.serviceConfig.SupplementaryGroups = [
    config.users.groups.acme-certs.name
  ];
}
