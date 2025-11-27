# SPDX-License-Identifier: MIT

{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) listToAttrs readFile;
  inherit (pkgs) replaceVars;
in
{
  security.acme = {
    acceptTerms = true;
    certs = {
      "jihli.infra.largeandhighquality.com" = {
        domain = "jihli.infra.largeandhighquality.com";
        keyType = "rsa4096";
        postRun = readFile (
          replaceVars ./update-printer {
            inherit (pkgs) coreutils curl openssl;
          }
        );
      };
      "zhloe.infra.largeandhighquality.com".domain = "zhloe.infra.largeandhighquality.com";
    };
    defaults = {
      credentialsFile = "/run/secrets/linode";
      dnsProvider = "linodev4";
      email = "randy@largeandhighquality.com";
      group = config.users.groups.acme-certs.name;
    };
  };

  sops.secrets = listToAttrs (
    map
      (secret: {
        name = secret;
        value = {
          mode = "400";
          owner = config.users.users.acme.name;
          group = config.users.groups.acme-certs.name;
        };
      })
      [
        "hp_printer"
        "linode"
      ]
  );

  systemd.services = listToAttrs (
    map
      (domain: {
        name = domain;
        value.serviceConfig.SupplementaryGroups = [ config.users.groups.keys.name ];
      })
      [
        "acme-jihli.infra.largeandhighquality.com"
        "acme-zhloe.infra.largeandhighquality.com"
      ]
  );

  users.groups.acme-certs = { };
}
