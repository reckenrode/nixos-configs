{ pkgs
, ...
}:

{
  services.avahi = {
    enable = true;
    publish.enable = true;
    extraServiceFiles = {
      time-machine = ''
        <?xml version="1.0" standalone='no'?>
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
            <host-name>meteion.infra.largeandhighquality.com</host-name>
          </service>
        </service-group>
      '';
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
