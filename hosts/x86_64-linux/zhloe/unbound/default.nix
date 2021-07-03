{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      unbound_doh = prev.unbound.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ final.nghttp2 ];
        configureFlags = old.configureFlags ++ [
          "--with-libnghttp2=${final.nghttp2.dev}"
        ];
      });
    })
  ];

  security.acme.certs."infra.largeandhighquality.com".postRun = "${pkgs.systemd}/bin/systemctl restart unbound.service";

  services.unbound = let
    certPath = config.security.acme.certs."infra.largeandhighquality.com".directory;
  in {
    package = pkgs.unbound_doh;
    settings = {
      server = {
        access-control = [
          "192.168.238.1/24 allow"
          "fe80::/64 allow"
          "fda9:51fe:3bbf:c9f::/64 allow"
        ];
        interface = [
          "192.168.238.1"
          "fe80::2e0:67ff:fe15:ced3%enp2s0"
          "fda9:51fe:3bbf:c9f:2e0:67ff:fe15:ced3@443"
          "fda9:51fe:3bbf:c9f:2e0:67ff:fe15:ced3@853"
        ];
        local-zone = [
          "largeandhighquality.com. transparent"
        ];
        local-data = [
          ''"jihli.infra.largeandhighquality.com AAAA fda9:51fe:3bbf:c9f:c665:16ff:fedd:7d5b"''
          ''"zhloe.infra.largeandhighquality.com AAAA fda9:51fe:3bbf:c9f:2e0:67ff:fe15:ced3"''
        ];
        tls-service-key = "${certPath}/key.pem";
        tls-service-pem = "${certPath}/fullchain.pem";
      };
    };
  };

  systemd.services.unbound.serviceConfig.SupplementaryGroups = [
    config.users.groups.acme-certs.name
  ];

  networking.nftables.ruleset = builtins.readFile ./unbound.nft;
}
