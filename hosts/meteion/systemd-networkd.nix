# SPDX-License-Identifier: MIT

{
  systemd.network.networks.wlan = {
    enable = true;
    matchConfig.Name = "wlan";
    networkConfig = {
      DHCP = "ipv4";
      IPv6PrivacyExtensions = true;
      IPv6AcceptRA = true;
    };
  };
}
