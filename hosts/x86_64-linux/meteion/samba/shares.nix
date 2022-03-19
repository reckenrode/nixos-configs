{ ... }:

{
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

  services.samba.shares.tabletop-group = {
    path = "/srv/samba/tabletop-group";
    browseable = "yes";
    "guest ok" = "yes";
    writeable = "no";
    "write list" = "reckenrode";
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
}
