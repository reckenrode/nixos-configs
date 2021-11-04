{ ... }:

{
  networking.nftables.ruleset = builtins.readFile ./dhcp6-client.nft;

  systemd.network.networks.lan = {
    enable = true;
    matchConfig.Name = "enabcm6e4ei0";
    networkConfig = {
      DHCP = "yes";
      IPv6PrivacyExtensions = true;
      IPv6AcceptRA = true;
    };
  };
}
