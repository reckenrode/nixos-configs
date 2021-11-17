{ config, pkgs, ... }:

{
  # security.acme = {
  #   acceptTerms = true;
  #   certs = {
  #     "largeandhighquality.com" = {
  #       credentialsFile = "/run/secrets/linode";
  #       dnsProvider = "linodev4";
  #       domain = "largeandhighquality.com";
  #       email = "randy@largeandhighquality.com";
  #       extraDomainNames = [
  #         "turn.largeandhighquality.com"
  #         "vtt.largeandhighquality.com"
  #         "www.largeandhighquality.com"
  #       ];
  #       group = config.users.groups.acme-certs.name;
  #       # postRun TODO: this should trigger a unit that other things can listen to for renewals.
  #     };
  #   };
  # };

  # sops.secrets.linode_token =
  #   let
  #     inherit (config.systemd.services."acme-largeandhighquality.com") serviceConfig;
  #   in
  #   {
  #     mode = "400";
  #     owner = serviceConfig.User;
  #     group = serviceConfig.Group;
  #   };

  # systemd.services."acme-largeandhighquality.com".serviceConfig.SupplementaryGroups = [
  #   config.users.groups.keys.name
  # ];

  users.groups.acme-certs = {};
}
