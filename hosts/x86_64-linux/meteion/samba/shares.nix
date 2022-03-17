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
