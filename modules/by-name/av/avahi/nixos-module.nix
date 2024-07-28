# SPDX-License-Identifier: MIT

{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.services.avahi.enable {
    networking.nftables.ruleset = ''
      table inet filter {
        chain input {
          ip saddr 192.168.238.0/24 tcp dport microsoft-ds accept
          ip saddr 192.168.238.0/24 udp sport mdns ip daddr 224.0.0.251/32 udp dport mdns accept
          ip6 saddr fe80::/64 udp sport mdns ip6 daddr ff02::fb/128 udp dport mdns accept
        }
      }
    '';
  };
}
