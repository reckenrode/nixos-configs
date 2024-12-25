# SPDX-License-Identifier: MIT

{
  pkgs,
  ...
}:

{
  # services.elasticsearch.enable = true;

  services.samba = {
    enable = true;
    settings.global = {
      "guest account" = "samba-guest";
      "map to guest" = "Bad User";
    };
  };

  services.samba.settings.reckenrode = {
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

  services.samba.settings.weiweilin = {
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

  services.samba.settings.tabletop-group = {
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

  services.time-machine.enable = true;
}
