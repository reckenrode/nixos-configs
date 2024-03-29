# SPDX-License-Identifier: MIT

{ config, ... }:

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
    certs = {
      "${config.services.foundryvtt.hostName}" = {
        credentialsFile = "/run/secrets/linode";
        dnsProvider = "linodev4";
        domain = config.services.foundryvtt.hostName;
        email = "randy@largeandhighquality.com";
        group = config.users.groups.acme-certs.name;
        postRun = "systemctl restart caddy";
      };
    };
  };

  services.caddy = {
    enable = true;
    extraConfig = ''
      ${config.services.foundryvtt.hostName} {
        header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
        encode zstd gzip

        @static {
          path /cards/*
          path /css/*
          path /docs/*
          path /fonts/*
          path /icons/*
          path /lang/*
          path /sounds/*
          path /ui/*
          path /scripts/greensock/*
          file /scripts/foundry.js
          file /scripts/setup.js
        }
        file_server /public {
          root /srv/vtt
          precompressed zstd br gzip
        }
        @non_static {
          not {
            path /cards/*
            path /css/*
            path /docs/*
            path /fonts/*
            path /icons/*
            path /lang/*
            # path /scripts/*
            path /sounds/*
            path /scripts/greensock/*
            file /scripts/foundry.js
            file /scripts/setup.js
          }
        }
        reverse_proxy @non_static localhost:30000
      }
    '';
  };
}
