# SPDX-License-Identifier: MIT

{
  pkgs,
  inputs,
  ...
}:

{
  systemd.network.networks.wlan = {
    enable = true;
    matchConfig.Type = "wlan";
    networkConfig = {
      DHCP = "ipv4";
      IPv6PrivacyExtensions = true;
      IPv6AcceptRA = true;
    };
  };
}
