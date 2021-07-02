{ pkgs, ... }:
let
  dhcpV4Config = ./kea-dhcp4.conf;
  dhcpV6Config = ./kea-dhcp6.conf;
  mkKeaUnit = (bin: config: let
    pidLocation = with builtins; "/run/kea/" + (baseNameOf (substring 0 ((stringLength config) - 5) config)) + ".${bin}.pid";
  in {
    enable = true;
    description = "Kea: a modern, open source DHCP server";
    after = [ "time-sync.target" "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = with pkgs; {
      Type = "exec";
      Environment = "KEA_PIDFILE_DIR=/run/kea";
      ExecReload = "${utillinux}/bin/kill -HUP `${coreutils}/bin/cat ${pidLocation}`";
      ExecStart = "${pkgs.kea}/bin/${bin} -c ${config}";
      PIDFile = pidLocation;
      Restart = "on-failure";
      RuntimeDirectory = "kea";
      RuntimeDirectoryMode = "0755";
      StateDirectory = "kea";
      StateDirectoryMode = "0755";
    };
  });
in
{
  networking.nftables.ruleset = builtins.readFile ./kea.nft;
  systemd.services.kea-dhcp4 = mkKeaUnit "kea-dhcp4" dhcpV4Config;
  systemd.services.kea-dhcp6 = mkKeaUnit "kea-dhcp6" dhcpV6Config;
}
