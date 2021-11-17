{ ... }:

{
  services.dhcpV6Client = {
    openFirewall = true;
    interfaces = [ "eth0" ];
  };

  services.resolved.dnssec = "false";

  systemd.network.networks.lan = {
    enable = true;
    matchConfig.Name = "eth0";
    networkConfig = {
      DHCP = "ipv4";
      IPv6PrivacyExtensions = true;
      IPv6AcceptRA = true;
    };
  };
}
