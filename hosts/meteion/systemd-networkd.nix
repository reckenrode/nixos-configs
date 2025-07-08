# SPDX-License-Identifier: MIT

{
  pkgs,
  inputs,
  ...
}:

{
  systemd.network.networks.lan = {
    enable = true;
    matchConfig.Type = "ether";
    networkConfig = {
      DHCP = "ipv4";
      IPv6PrivacyExtensions = true;
      IPv6AcceptRA = true;
    };
  };
}
