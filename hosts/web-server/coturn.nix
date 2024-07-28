# SPDX-License-Identifier: MIT

{ config, ... }:

let
  turnHostName = "turn.largeandhighquality.com";
in
{
  #  networking.nftables.ruleset =
  #    let
  #      listeningPort = builtins.toString config.services.coturn.tls-listening-port;
  #      minPort = builtins.toString config.services.coturn.min-port;
  #      maxPort = builtins.toString config.services.coturn.max-port;
  #    in
  #    ''
  #      table inet filter {
  #        chain input {
  #          tcp dport { ${listeningPort}, ${minPort} - ${maxPort} } accept
  #          udp dport { ${listeningPort}, ${minPort} - ${maxPort} } accept
  #        }
  #      }
  #    '';

  security.acme = {
    acceptTerms = true;
    certs = {
      "${turnHostName}" = {
        domain = turnHostName;
        postRun = "systemctl restart coturn";
      };
    };
  };

  services.coturn =
    let
      certPath = "/var/lib/acme/${turnHostName}";
    in
    {
      enable = false;
      cert = "${certPath}/fullchain.pem";
      pkey = "${certPath}/key.pem";
      no-tcp = true;
      no-udp = true;
      no-cli = true;
      lt-cred-mech = true;
      secure-stun = true;
      static-users-file = "/run/secrets/coturn-users";
      extraConfig = ''
        no-tlsv1
        no-tlsv1_1
        no-prometheus
        no-rfc5780
        no-stun-backward-compatibility
        response-origin-only-with-rfc5780
      '';
    };

  sops.secrets.coturn-users = {
    mode = "0400";
    owner = config.systemd.services.coturn.serviceConfig.User;
    group = config.systemd.services.coturn.serviceConfig.Group;
  };

  systemd.services.coturn.serviceConfig.SupplementaryGroups = [ config.users.groups.keys.name ];
  users.users.turnserver.extraGroups = [ "acme-certs" ];
}
