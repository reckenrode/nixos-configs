{ config, pkgs, ... }:

let
  inherit (builtins) listToAttrs;
in
{
  security.acme = {
    acceptTerms = true;
    certs = {
      "jihli.infra.largeandhighquality.com" = {
        credentialsFile = "/run/secrets/linode";
        dnsProvider = "linodev4";
        domain = "jihli.infra.largeandhighquality.com";
        email = "randy@largeandhighquality.com";
        group = config.users.groups.acme-certs.name;
        keyType = "rsa4096";
        postRun = builtins.readFile (pkgs.substituteAll {
          inherit (pkgs) coreutils curl openssl;
          src = ./update-printer;
        });
      };
      "zhloe.infra.largeandhighquality.com" = {
        credentialsFile = "/run/secrets/linode";
        dnsProvider = "linodev4";
        domain = "zhloe.infra.largeandhighquality.com";
        email = "randy@largeandhighquality.com";
        group = config.users.groups.acme-certs.name;
      };
    };
    defaults.dnsResolver = "1.1.1.1:53";
  };

  sops.secrets = listToAttrs (map
    (secret: {
      name = secret;
      value = {
        mode = "400";
        owner = config.users.users.acme.name;
        group = config.users.groups.acme-certs.name;
      };
    }) [ "hp_printer" "linode" ]);

  systemd.services = listToAttrs (map
    (domain: {
      name = domain;
      value.serviceConfig.SupplementaryGroups = [
        config.users.groups.keys.name
      ];
    }) [ "acme-jihli.infra.largeandhighquality.com" "acme-zhloe.infra.largeandhighquality.com" ]);

  users.groups.acme-certs = { };
}
