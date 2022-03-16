{ ... }:

{
  services.dhcpV6Client = {
    openFirewall = true;
    interfaces = [ "enp3s0" ];
  };

  services.resolved.dnssec = "false";

  systemd.network.networks.lan = {
    enable = true;
    matchConfig.Name = "enp3s0";
    networkConfig = {
      DHCP = "ipv4";
      IPv6PrivacyExtensions = true;
      IPv6AcceptRA = true;
    };
  };
}
