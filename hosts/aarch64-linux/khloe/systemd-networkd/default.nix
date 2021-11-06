{ ... }:

{
  networking.nftables.ruleset = builtins.readFile ./dhcp6-client.nft;

  services.resolved.dnssec = "false";

  systemd.network.networks.lan = {
    enable = true;
    matchConfig.Name = "eth0";
    networkConfig = {
      DHCP = "yes";
      IPv6PrivacyExtensions = true;
      IPv6AcceptRA = true;
    };
  };
}
