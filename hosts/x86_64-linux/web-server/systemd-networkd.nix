{ ... }:

{
  systemd.network.networks.wan = {
    enable = true;
    matchConfig.Name = "enp*";
    networkConfig = {
      DHCP = "ipv4";
      IPv6PrivacyExtensions = false;
      IPv6AcceptRA = true;
    };
  };
}
