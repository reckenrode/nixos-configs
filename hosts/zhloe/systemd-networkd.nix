# SPDX-License-Identifier: MIT

{
  services.dhcpV6Client = {
    openFirewall = true;
    interfaces = [ "enp1s0" ];
  };

  networking.nftables.ruleset = ''
    table ip firewall-cfg {
      chain postrouting {
        type nat hook postrouting priority 100
        oifname enp1s0 masquerade
      }
    }
  '';

  systemd.network.config.networkConfig = {
    IPv4Forwarding = true;
    IPv6Forwarding = true;
  };

  systemd.network.networks.lan = {
    enable = true;
    matchConfig.Name = "enp2s0";

    networkConfig = {
      Address = "192.168.238.1/24";
      Domains = [ "~infra.largeandhighquality.com" ];
      DNS = "fda9:51fe:3bbf:c9f:2e0:67ff:fe15:ced3#zhloe.infra.largeandhighquality.com";
      DNSOverTLS = true;
      DNSSEC = true;
      DHCPPrefixDelegation = true;
      IPv6SendRA = true;
    };

    ipv6SendRAConfig = {
      OtherInformation = true;
      RouterLifetimeSec = 5400;
      DNS = "_link_local";
      Domains = "infra.largeandhighquality.com";
      DNSLifetimeSec = 16200;
    };

    extraConfig = ''
      [IPv6Prefix]
      Prefix=fda9:51fe:3bbf:c9f::/64
      Assign=true
    '';
  };

  systemd.network.networks.wan = {
    enable = true;
    matchConfig.Name = "enp1s0";

    networkConfig = {
      DHCP = "ipv4";
      DNS = [ "fda9:51fe:3bbf:c9f:2e0:67ff:fe15:ced3#zhloe.infra.largeandhighquality.com" ];
      DNSOverTLS = true;
      DNSSEC = true;
      IPv6PrivacyExtensions = false;
      IPv6AcceptRA = true;
    };

    dhcpV4Config = {
      ClientIdentifier = "mac";
      UseDNS = false;
    };

    dhcpV6Config = {
      UseDNS = false;
    };

#    routes = [
#      {
#        Type = "blackhole";
#        Destination = "192.168.100.1/32";
#      }
#    ];
  };
}
