# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

{
  # services.elasticsearch.enable = true;

  services.samba = {
    enable = true;
    extraConfig = ''
      guest account = samba-guest
      map to guest = Bad User
    '';
  };

  services.samba.shares.reckenrode = {
    path = "/srv/samba/reckenrode";
    "valid users" = "reckenrode";
    browseable = "yes";
    public = "no";
    writeable = "yes";
    "guest ok" = "no";
    "force user" = "reckenrode";
    "create mask" = "0640";
    "directory mask" = "0750";
  };

  services.samba.shares.weiweilin = {
    path = "/srv/samba/weiweilin";
    "valid users" = "weiweilin";
    browseable = "yes";
    public = "no";
    writeable = "yes";
    "guest ok" = "no";
    "force user" = "weiweilin";
    "create mask" = "0640";
    "directory mask" = "0750";
  };

  services.samba.shares.tabletop-group = {
    path = "/srv/samba/tabletop-group";
    browseable = "yes";
    "guest ok" = "yes";
    writeable = "no";
    "write list" = "reckenrode";
  };

  users = {
    groups.samba-guest = { };
    users.samba-guest = {
      isSystemUser = true;
      description = "Samba guest users";
      group = "samba-guest";
      home = "/var/empty";
      createHome = false;
      shell = pkgs.shadow;
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/samba 0755 root root"
    "d /srv/samba/reckenrode 0755 reckenrode root"
    "d /srv/samba/tabletop-group 0755 samba-guest samba-guest"
    "d /srv/samba/weiweilin 0755 weiweilin root"
  ];

  services.time-machine.enable = true;
}
