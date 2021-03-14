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

  services.caddy = {
    enable = true;
    email = "randy@largeandhighquality.com";
    config = ''
      ${config.services.foundryvtt.hostname} {
        header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
        encode zstd gzip
        reverse_proxy localhost:30000
      }
    '';
  };

  services.foundryvtt = {
    enable = true;
    hostname = "vtt.largeandhighquality.com";
    minifyStaticFiles = true;
    proxyPort = 443;
    proxySSL = true;
    upnp = false;
  };
}
