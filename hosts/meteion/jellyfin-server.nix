{
  services.jellyfin.enable = true;

  networking.nftables.ruleset = ''
    table inet firewall-cfg {
      chain input {
        tcp dport { 8096, 8920 } accept
        udp dport { 1900, 7359 } accept
      }
    }
  '';
}
