# SPDX-License-Identifier: MIT

{ config, ... }:

{
  security.acme = {
    acceptTerms = true;
    certs = {
      "largeandhighquality.com" = {
        domain = "largeandhighquality.com";
        extraDomainNames = [
          "www.largeandhighquality.com"
        ];
      };
    };
    defaults = {
      credentialsFile = "/run/secrets/linode";
      dnsProvider = "linodev4";
      email = "randy@largeandhighquality.com";
      group = config.users.groups.acme-certs.name;
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

  users.groups.acme-certs = { };
}
