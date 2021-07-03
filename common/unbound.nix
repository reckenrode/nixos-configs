{ pkgs, ... }:
{
  networking.nftables.ruleset = builtins.readFile ./unbound.nft;

  services.unbound = {
    enable = true;
    settings = {
      forward-zone = [
        {
          name = ".";
          forward-tls-upstream = true;
          forward-addr = [
            "2606:4700:4700::1111@853#cloudflare-dns.com"
            "2606:4700:4700::1001@853#cloudflare-dns.com"
          ];
        }
      ];
      server = {
        # Mitigate DNS-rebinding attacks
        private-address = [
          "198.18.0.0/15"      # Benchmarking
          "255.255.255.255/32" # Broadcast
          "0.0.0.0/8 "         # Current network
          "192.0.0.0/24"       # IETF protocol assignments
          "192.0.2.0/24"       # IETF TEST-NET-1
          "198.51.100.0/24"    # IETF TEST-NET-2
          "203.0.113.0/24"     # IETF TEST-NET-3
          "224.0.0.0/4 "       # IP multicast
          "169.254.0.0/16"     # Link-local
          "127.0.0.0/8 "       # Loopback
          "10.0.0.0/8 "        # Private
          "172.16.0.0/12"      # Private
          "192.168.0.0/16"     # Private
          "192.88.99.0/24"     # Reserved
          "240.0.0.0/4 "       # Reserved for future use
          "100.64.0.0/10"      # Shared (carrier-grade NAT)
          "2002::/16"          # 6to4
          "::0"                # Default route
          "::/128"             # Default address
          "100::/64"           # Discard prefix
          "2001:db8::/32"      # Example
          "fe80::/10"          # Link-local
          "::1/128"            # Loopback
          "ff00::/8"           # Multicast
          "::ffff:0:0/96"      # IPv4 mapped
          "::ffff:0:0:0/96"    # IPv4 translated
          "64:ff9b::/96"       # IPv4/IPv6 translation
          "2001:20::/28"       # ORCHIDv2
          "2001::/32"          # Teredo tunneling
          "fc00::/7"           # Unique local
        ];

        # Performance Optimizations
        prefetch = true;
        prefetch-key = true;
        msg-cache-size = "128m";
        rrset-cache-size = "256m";
      };
    };
  };
}
