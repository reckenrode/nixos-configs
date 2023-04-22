# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.networking.wireless.iwd.enable {
    sops.secrets.wifi.mode = "400";

    system.activationScripts.iwdNetworkSetup = {
      text = ''
        [ x"$(shopt -s nullglob; echo /var/lib/iwd/*.psk)" != x"" ] && rm /var/lib/iwd/*.psk
        while read -r SSID PreSharedKey; do
          install -m400 -o root -g root \
            -D <(printf "[Security]\nPreSharedKey=$PreSharedKey\n") \
            "/var/lib/iwd/$SSID.psk"
        done < /run/secrets/wifi
      '';
      deps = [ "setupSecrets" ];
    };

    boot.extraModprobeConfig = ''
      options iwlwifi 11n_disable=8
    '';

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan[0-9]", TAG+="systemd", ENV{SYSTEMD_WANTS}="iwd-disable-power-management@$name.service"
    '';

    systemd.services."iwd-disable-power-management@" = {
      enable = true;
      requires = [ "sys-subsystem-net-devices-%i.device" ];
      after = [ "network.target" "iwd.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getBin pkgs.wirelesstools}/bin/iwconfig %i power off";
      };
    };
  };
}
