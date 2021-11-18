{ config, pkgs, ... }:

{
  security.acme = {
    acceptTerms = true;
    certs = {
      "largeandhighquality.com" = {
        credentialsFile = "/run/secrets/linode";
        dnsProvider = "linodev4";
        domain = "largeandhighquality.com";
        email = "randy@largeandhighquality.com";
        extraDomainNames = [
          "www.largeandhighquality.com"
        ];
        group = config.users.groups.acme-certs.name;
      };
    };
  };

  sops.secrets.linode = {
    mode = "400";
    owner = config.users.users.acme.name;
    group = config.users.groups.acme-certs.name;
  };

  systemd.services."acme-largeandhighquality.com".serviceConfig.SupplementaryGroups = [
    config.users.groups.keys.name
  ];

  users.groups.acme-certs = {};
}
