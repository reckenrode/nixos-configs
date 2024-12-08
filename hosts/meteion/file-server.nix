# SPDX-License-Identifier: MIT
{
  config,
  ...
}:

let
  domain = "meteion.infra.largeandhighquality.com";
in
{
  networking.nftables.ruleset = ''
    table inet filter {
      chain input {
        tcp dport { http, https } accept
        udp dport { http, https } accept
      }
    }
  '';

  security.acme = {
    acceptTerms = true;
    certs.${domain} = {
      postRun = "systemctl reload caddy";
    };
    defaults = {
      credentialsFile = "/run/secrets/linode";
      dnsProvider = "linodev4";
      email = "randy@largeandhighquality.com";
      group = config.users.groups.acme-certs.name;
    };
  };

  services.caddy = {
    enable = true;
    extraConfig = ''
      ${domain} {
        tls /var/lib/acme/${domain}/fullchain.pem /var/lib/acme/${domain}/key.pem

        header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"

        encode zstd gzip

        redir /jellyfin /jellyfin/
        reverse_proxy /jellyfin/* 127.0.0.1:8096

        handle /files/* {
          uri strip_prefix /files
          root * /srv/samba/tabletop-group
          file_server {
            browse
            hide .DS_Store
          }
        }

        root * /srv/www
        file_server
      }
    '';
  };

  sops.secrets.linode = {
    mode = "400";
    owner = config.users.users.acme.name;
    group = config.users.groups.acme-certs.name;
  };

  systemd.tmpfiles.rules = [ "d /srv/www 0755 root root" ];

  users.users.caddy.extraGroups = [ "acme-certs" ];

  users.groups.acme-certs = { };
}
