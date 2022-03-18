{ pkgs
, ...
}:

{
  services.avahi = {
    enable = true;
    publish.userServices = true;
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
          <service>
            <type>_device-info._tcp</type>
            <port>0</port>
            <txt-record>model=MacSamba@ECOLOR=226,226,224</txt-record>
          </service>
          <service>
            <type>_adisk._tcp</type>
            <txt-record>sys=waMa=0,adVF=0x100</txt-record>
            <txt-record>dk0=adVN=TimeMachine,adVF=0x82</txt-record>
            <host-name>meteion.infra.largeandhighquality.com</host-name>
          </service>
        </service-group>
      '';
    };
  };

  services.samba.shares.time-machine = {
    path = "/srv/time-machine";
    "valid users" = "reckenrode weiweilin";
    public = "no";
    writeable = "yes";
    "force group" = "time-machine";
    "guest ok" = "no";
    "fruit:time machine" = "yes";
    "fruit:time machine max size" = "4TB";
  };

  users.groups.time-machine = { };
}
