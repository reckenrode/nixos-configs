# SPDX-License-Identifier: MIT

{
  networking.firewall.enable = false;

  networking.nftables.ruleset = ''
    table inet filter {
      chain default_input {
        type filter hook input priority filter; policy drop;
        iif lo accept

        ct state invalid drop
        ct state established,related accept

        icmpv6 type { 1, 2, 3, 4, 128, 129, 133, 134, 135, 136, 141, 142, 148, 149 } accept
        icmpv6 type { 137 } ip6 hoplimit != 1 accept
        icmpv6 type { 130, 131, 132, 143, 151, 152, 153 } ip6 saddr fe80::/64 accept

        goto input
      }

      chain input {}
    }
  '';
}
