{ pkgs
, ...
}:

{
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.samba.shares.time-machine = {
    path = "/srv/time-machine";
    "valid users" = "time-machine";
    public = "no";
    writeable = "yes";
    "force user" = "time-machine";
    "force group" = "time-machine";
    "guest ok" = "no";
    "fruit:time machine" = "yes";
    "fruit:time machine max size" = "4TB";
  };

  users = {
    groups.time-machine = { };
    users.time-machine = {
      isSystemUser = true;
      description = "Time Machine Backups";
      group = "time-machine";
      home = "/var/empty";
      createHome = false;
      shell = pkgs.shadow;
    };
  };
}
