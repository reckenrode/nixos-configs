{ config, pkgs, ... }:

{
  security.acme = {
    acceptTerms = true;
    certs = {
      "infra.largeandhighquality.com" = {
        credentialsFile = "/run/secrets/linode";
        dnsProvider = "linodev4";
        domain = "*.infra.largeandhighquality.com";
        email = "randy@largeandhighquality.com";
        group = config.users.groups.acme-certs.name;
        keyType = "rsa4096";
        postRun = builtins.readFile (pkgs.substituteAll {
          src = ./update-printer;
          inherit (pkgs) coreutils curl openssl;
        });
      };
    };
  };

  sops.secrets = builtins.listToAttrs (map (secret: {
    name = secret;
    value = {
      mode = "0400";
      owner = config.systemd.services."acme-infra.largeandhighquality.com".serviceConfig.User;
      group = config.systemd.services."acme-infra.largeandhighquality.com".serviceConfig.Group;
    };
  }) [ "hp_printer" "linode" ]);

  systemd.services."acme-infra.largeandhighquality.com".serviceConfig.SupplementaryGroups = [
    config.users.groups.keys.name
  ];
}
