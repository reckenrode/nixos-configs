{ config
, lib
, ...
}:

{
  networking.wireless.iwd.enable = true;

  sops.secrets.wifi = {
    mode = "400";
  };

  system.activationScripts = lib.mkIf config.services.samba.enable {
    iwdNetworkSetup = {
      text = ''
        [ x"$(shopt -s nullglob; echo /var/lib/iwd/*.psk)" != x"" ] && rm /var/lib/iwd/*.psk
        while read -r SSID PreSharedKey; do
          install -o root -g root -m400 -D <(printf "[Security]\nPreSharedKey=$PreSharedKey\n") \
            "/var/lib/iwd/$SSID.psk"
        done < /run/secrets/wifi
      '';
      deps = [ "setupSecrets" ];
    };
  };
}
