# SPDX-License-Identifier: MIT

{ lib, ... }:

let
  inherit (lib) substring;

  leasesDatabaseFor = type: {
    name = "/var/lib/kea/kea-leases${substring 4 1 type}.csv";
    type = "memfile";
    lfc-interval = 3600;
  };

  defaultLeasesProcessing = {
    reclaim-timer-wait-time = 10;
    flush-reclaimed-timer-wait-time = 25;
    hold-reclaimed-time = 3600;
    max-reclaim-leases = 100;
    max-reclaim-time = 250;
    unwarned-reclaim-cycles = 5;
  };

  loggerFor = type: [
    {
      name = "kea-dhcp${substring 4 1 type}";
      output_options = [ { output = "stderr"; } ];
      severity = "INFO";
      debuglevel = 0;
    }
  ];
in
{
  networking.nftables.ruleset = ''
    table inet filter {
      chain input {
        iifname enp2s0 ip saddr 192.168.238.0/24 udp sport bootpc ip daddr 192.168.238.1 udp dport bootps accept
        iifname enp2s0 ip saddr 0.0.0.0 udp sport bootpc ip daddr { 192.16.238.255, 255.255.255.255 } udp dport bootps accept
        iifname enp2s0 ip6 saddr fe80::/64 udp sport dhcpv6-client ip6 daddr ff02::1:2/128 udp dport dhcpv6-server accept
      }
    }
  '';

  services.kea.dhcp4 = {
    enable = true;
    settings = {
      interfaces-config.interfaces = [ "enp2s0" ];

      lease-database = leasesDatabaseFor "dhcp4";
      expired-leases-processing = defaultLeasesProcessing;

      renew-timer = 900;
      rebind-timer = 1800;
      valid-lifetime = 3600;

      subnet4 =
        let
          legacyDNS = {
            option-data = [
              {
                name = "domain-name-servers";
                data = "192.168.238.1";
              }
              {
                name = "domain-search";
                data = "infra.largeandhighquality.com";
              }
            ];
          };
        in
        [
          {
            id = 1;
            subnet = "192.168.238.1/24";
            pools = [ { pool = "192.168.238.4 - 192.168.238.254"; } ];

            option-data = [
              {
                name = "routers";
                data = "192.168.238.1";
              }
            ];

            reservations = [
              # Orbi Router
              (
                {
                  hw-address = "b0:39:56:87:73:c2";
                  ip-address = "192.168.238.2";
                }
                // legacyDNS
              )

              # Orbi Satellite
              (
                {
                  hw-address = "b0:39:56:87:83:0d";
                  ip-address = "192.168.238.3";
                }
                // legacyDNS
              )

              ({ hw-address = "f0:99:bf:01:9b:7c"; } // legacyDNS) # Airport Extreme
              ({ hw-address = "00:1d:c9:d8:4f:4b"; } // legacyDNS) # Aria Scale
              ({ hw-address = "fc:b4:67:57:c3:c8"; } // legacyDNS) # Hatch Rest 2
              ({ hw-address = "c4:65:16:dd:7d:5b"; } // legacyDNS) # HP LaserJet Printer
              ({ hw-address = "e8:da:20:c0:e8:67"; } // legacyDNS) # Nintendo Switch
              ({ hw-address = "bc:60:a7:a8:29:12"; } // legacyDNS) # PlayStation 4
            ];
          }
        ];

      loggers = loggerFor "dhcp4";
    };
  };

  services.kea.dhcp6 = {
    enable = true;
    settings = {
      interfaces-config.interfaces = [ "enp2s0" ];

      data-directory = "/var/lib/kea";

      lease-database = leasesDatabaseFor "dhcp6";
      expired-leases-processing = defaultLeasesProcessing;

      renew-timer = 3600;
      rebind-timer = 7200;
      preferred-lifetime = 604800;
      valid-lifetime = 2592000;

      subnet6 = [
        {
          id = 1;
          subnet = "fda9:51fe:3bbf:c9f::/64";

          option-data = [
            {
              name = "dns-servers";
              data = "fe80::2e0:67ff:fe15:ced3";
              always-send = true;
            }
            {
              name = "domain-search";
              data = "infra.largeandhighquality.com";
              always-send = true;
            }
          ];
        }
      ];

      loggers = loggerFor "dhcp6";
    };
  };
}
