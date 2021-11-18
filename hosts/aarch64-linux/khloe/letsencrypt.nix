{ config, pkgs, ... }:

{
  security.acme = {
    acceptTerms = true;
    certs = {
      "khloe.infra.largeandhighquality.com" = {
        credentialsFile = "/run/secrets/linode";
        dnsProvider = "linodev4";
        domain = "khloe.infra.largeandhighquality.com";
        email = "randy@largeandhighquality.com";
        group = config.users.groups.acme-certs.name;
        postRun = "systemctl restart caddy";
      };
    };
  };

  sops.secrets.linode =
    let
      inherit (config.systemd.services."acme-khloe.infra.largeandhighquality.com") serviceConfig;
    in
    {
      mode = "400";
      owner = config.users.users.acme.name;
      group = config.users.groups.acme-certs.name;
    };

  systemd.services."acme-khloe.infra.largeandhighquality.com".serviceConfig.SupplementaryGroups = [
    config.users.groups.keys.name
  ];

  users.groups.acme-certs = {};
}
