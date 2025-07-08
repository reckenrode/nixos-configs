# SPDX-License-Identifier: MIT

{ config, pkgs, ... }:

let
  unboundWithDoH = pkgs.unbound-with-systemd.override {
    withDoH = true;
    withTFO = true;
  };
in
{
  networking.nftables.ruleset = ''
    table inet firewall-cfg {
      chain prerouting { # This is necessary because some Android phones hardcode the DNS servers.
        type nat hook prerouting priority 0; policy accept;
        iifname enp2s0 meta l4proto { tcp, udp } ip6 saddr {fda9:51fe:3bbf:c9f::/64, fe80::/64} ip6 daddr != {fda9:51fe:3bbf:c9f::/64, fe80::/64} th dport { domain, 853 } redirect
        iifname enp2s0 meta l4proto { tcp, udp } ip  saddr                     192.168.238.0/24 ip  daddr !=                     192.168.238.0/24 th dport { domain, 853 } redirect
      }
    }

    table inet firewall-cfg {
      chain input {
        iifname enp2s0 meta l4proto { tcp, udp } ip6 saddr fda9:51fe:3bbf:c9f::/64 th dport { domain, https, 853 } accept
        iifname enp2s0 meta l4proto { tcp, udp } ip  saddr        192.168.238.0/24 th dport { domain, 853 } accept
        iifname enp2s0 meta l4proto { tcp, udp } ip6 saddr               fe80::/64 th dport { domain, 853 } accept
      }
    }
  '';

  security.acme.certs."zhloe.infra.largeandhighquality.com".postRun = "${pkgs.systemd}/bin/systemctl restart unbound.service";

  services.unbound =
    let
      certPath = config.security.acme.certs."zhloe.infra.largeandhighquality.com".directory;
    in
    {
      enable = true;
      package = unboundWithDoH;
      settings = {
        server = {
          access-control = [
            "192.168.238.1/24 allow"
            "fe80::/64 allow"
            "fda9:51fe:3bbf:c9f::/64 allow"
          ];

          interface = [
            "192.168.238.1"
            "192.168.238.1@853"
            "fe80::2e0:67ff:fe15:ced3%enp2s0"
            "fe80::2e0:67ff:fe15:ced3%enp2s0@853"
            "fda9:51fe:3bbf:c9f:2e0:67ff:fe15:ced3@443"
            "fda9:51fe:3bbf:c9f:2e0:67ff:fe15:ced3@853"
          ];

          local-zone = [ "largeandhighquality.com. transparent" ];

          local-data = [
            ''"jihli.infra.largeandhighquality.com AAAA fda9:51fe:3bbf:c9f:c665:16ff:fedd:7d5b"''
            ''"khloe.infra.largeandhighquality.com AAAA fda9:51fe:3bbf:c9f:dea6:32ff:fe37:1c49"''
            ''"meteion.infra.largeandhighquality.com AAAA fda9:51fe:3bbf:c9f:9e6b:ff:fe0c:9c1f"''
            ''"zhloe.infra.largeandhighquality.com AAAA fda9:51fe:3bbf:c9f:2e0:67ff:fe15:ced3"''
          ];

          tls-service-key = "${certPath}/key.pem";
          tls-service-pem = "${certPath}/fullchain.pem";

          # Mitigate DNS-rebinding attacks
          private-address = [
            "198.18.0.0/15" # Benchmarking
            "255.255.255.255/32" # Broadcast
            "0.0.0.0/8 " # Current network
            "192.0.0.0/24" # IETF protocol assignments
            "192.0.2.0/24" # IETF TEST-NET-1
            "198.51.100.0/24" # IETF TEST-NET-2
            "203.0.113.0/24" # IETF TEST-NET-3
            "224.0.0.0/4 " # IP multicast
            "169.254.0.0/16" # Link-local
            "127.0.0.0/8 " # Loopback
            "10.0.0.0/8 " # Private
            "172.16.0.0/12" # Private
            "192.168.0.0/16" # Private
            "192.88.99.0/24" # Reserved
            "240.0.0.0/4 " # Reserved for future use
            "100.64.0.0/10" # Shared (carrier-grade NAT)
            "2002::/16" # 6to4
            "::0" # Default route
            "::/128" # Default address
            "100::/64" # Discard prefix
            "2001:db8::/32" # Example
            "fe80::/10" # Link-local
            "::1/128" # Loopback
            "ff00::/8" # Multicast
            "::ffff:0:0/96" # IPv4 mapped
            "::ffff:0:0:0/96" # IPv4 translated
            "64:ff9b::/96" # IPv4/IPv6 translation
            "2001:20::/28" # ORCHIDv2
            "2001::/32" # Teredo tunneling
            "fc00::/7" # Unique local
          ];

          # Performance Optimizations
          prefetch = true;
          prefetch-key = true;
          msg-cache-size = "128m";
          rrset-cache-size = "256m";
        };
      };
    };

  systemd.services.unbound = {
    wants = [ "sys-subsystem-net-devices-enp2s0.device" ];
    after = [ "sys-subsystem-net-devices-enp2s0.device" ];
    serviceConfig.SupplementaryGroups = [ config.users.groups.acme-certs.name ];
  };
}
