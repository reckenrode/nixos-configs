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

  security.acme.certs."infra.largeandhighquality.com".postRun = "${pkgs.systemd}/bin/systemctl reload unbound.service";

  services.unbound = {
    allowedAccess = [ "192.168.238.1/24" "fe80::/64" ];
    interfaces = [ "192.168.238.1" "fe80::2e0:67ff:fe15:ced3%enp2s0" ];
    extraConfig = let
      certPath = config.security.acme.certs."infra.largeandhighquality.com".directory;
    in builtins.readFile (pkgs.substituteAll { src = ./unbound.conf; inherit certPath; });
    package = pkgs.unbound_doh;
  };

  networking.nftables.ruleset = builtins.readFile ./unbound.nft;
}
