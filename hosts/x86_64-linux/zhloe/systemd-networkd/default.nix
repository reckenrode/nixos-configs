{ ... }:

{
  services.dhcpV6Client = {
    openFirewall = true;
    interfaces = [ "enp1s0" ];
  };

  networking.nftables.ruleset = builtins.readFile ./masquerade.nft;

  services.resolved = {
    dnssec = "true";
    extraConfig = "DNSOverTLS=true";
  };

  systemd.network.networks.lan = {
    enable = true;
    matchConfig.Name = "enp2s0";
    networkConfig = {
      Address = "192.168.238.1/24";
      Domains = [ "~infra.largeandhighquality.com" ];
      DNS = "192.168.238.1#zhloe.infra.largeandhighquality.com";
      DHCPv6PrefixDelegation = true;
      IPv6SendRA = true;
    };
    ipv6SendRAConfig = {
      OtherInformation = true;
      RouterLifetimeSec = 5400;
      DNS = "_link_local";
      Domains = "infra.largeandhighquality.com";
      DNSLifetimeSec = "infinity";
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
      DNS = [ "1.1.1.1#cloudflare-dns.com" "1.0.0.1#cloudflare-dns.com" ];
      IPv6PrivacyExtensions = false;
      IPv6AcceptRA = true;
      IPForward = true;
    };
    dhcpV4Config = {
      ClientIdentifier = "mac";
      UseDNS = false;
    };
    routes = [
      { routeConfig = { Type = "blackhole"; Destination = "192.168.100.1/32"; }; }
    ];
  };
}
