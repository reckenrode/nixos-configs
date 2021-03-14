{ config, ... }:

let turnHostName = "turn.largeandhighquality.com"; in
{
  imports = [
    ./coturn-ext.nix
  ];

  networking.nftables.ruleset = let
    listeningPort = builtins.toString config.services.coturn.tls-listening-port;
    minPort = builtins.toString config.services.coturn.min-port;
    maxPort = builtins.toString config.services.coturn.max-port;
  in ''
    table inet filter {
      chain input {
        tcp dport { ${listeningPort}, ${minPort} - ${maxPort} } accept
        udp dport { ${listeningPort}, ${minPort} - ${maxPort} } accept
      }
    }
  '';

  security.acme = {
    acceptTerms = true;
    certs = {
      "${turnHostName}" = {
        email = "randy@largeandhighquality.com";
        group = "acme-certs";
        webroot = "/var/lib/acme/challenges";
        postRun = "systemctl restart coturn";
      };
    };
  };

  services.caddy = {
    enable = true;
    config = let
      challengeRoot = config.security.acme.certs.${turnHostName}.webroot;
    in ''
      http://${turnHostName} {
        encode zstd gzip
        root /.well-known/acme-challenge/* ${challengeRoot}
        file_server
      }
    '';
  };

  services.coturn = let
    certPath = "/var/lib/acme/${turnHostName}";
  in {
    enable = true;
    cert = "${certPath}/fullchain.pem";
    pkey = "${certPath}/key.pem";
    no-tcp = true;
    no-udp = true;
    no-cli = true;
    lt-cred-mech = true;
    secure-stun = true;
    extraConfig = ''
      no-tlsv1
      no-tlsv1_1
      #user=FIXME: generate this from a secret stored via sops-nix
    '';
  };

  users.groups.acme-certs = {};

  users.users.caddy.extraGroups = [ "acme-certs" ];
  users.users.turnserver.extraGroups = [ "acme-certs" ];
  users.users.acme.extraGroups = [ "acme-certs" ];
}
