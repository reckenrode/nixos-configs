{ config, pkgs, ... }:
{
  services.unbound = {
    allowedAccess = [ "192.168.238.1/24" "fe80::/64" ];
    interfaces = [ "192.168.238.1" "fe80::2e0:67ff:fe15:ced3%enp2s0" ];
    extraConfig = let
      certPath = config.security.acme.certs."infra.largeandhighquality.com".directory;
    in builtins.readFile (pkgs.substituteAll { src = ./unbound.conf; inherit certPath; });
    package = pkgs.unstable.unbound;
  };

  networking.nftables.ruleset = builtins.readFile ./unbound.nft;
}
