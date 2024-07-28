# SPDX-License-Identifier: MIT

{
  lib,
  config,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.services.samba.enable {
    networking.nftables.ruleset = ''
      table inet filter {
        chain input {
          ip6 saddr fda9:51fe:3bbf:c9f::/64 udp dport netbios-ns accept
          ip6 saddr fda9:51fe:3bbf:c9f::/64 udp dport netbios-dgm accept
          ip6 saddr fda9:51fe:3bbf:c9f::/64 tcp dport netbios-ssn accept
          ip6 saddr fda9:51fe:3bbf:c9f::/64 tcp dport microsoft-ds accept
          ip saddr 192.168.238.0/24 udp dport netbios-ns accept
          ip saddr 192.168.238.0/24 udp dport netbios-dgm accept
          ip saddr 192.168.238.0/24 tcp dport netbios-ssn accept
        }
      }
    '';

    services.samba = {
      package = pkgs.samba.override { enableMDNS = true; };
      securityType = "user";
      extraConfig = ''
        # Performance optimizations
        use sendfile = yes
        aio read size = 1
        aio write size = 1
        min receivefile size = 16384

        # Mac-friendly client settings
        #vfs objects = zfsacl catia fruit streams_xattr
        vfs objects = catia fruit streams_xattr
        fruit:aapl = yes
        fruit:resource = xattr
        fruit:metadata = stream
        fruit:encoding = native
        fruit:wipe_intentionally_left_blank_rfork = yes

        # Enable support for Spotlight queries
        #spotlight backend = elasticsearch
        #elasticsearch:address = localhost
        #elasticsearch:port = ${toString config.services.elasticsearch.port}
      '';
    };

    sops.secrets.smbpasswd.mode = "600";

    system.activationScripts.sambaUserSetup = {
      text = ''
        ${lib.getBin pkgs.samba}/bin/pdbedit \
          -i smbpasswd:/run/secrets/smbpasswd \
          -e tdbsam:/var/lib/samba/private/passdb.tdb
      '';
      deps = [ "setupSecrets" ];
    };
  };
}
