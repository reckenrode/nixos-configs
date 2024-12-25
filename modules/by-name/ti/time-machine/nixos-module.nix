# SPDX-License-Identifier: MIT

{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) types;

  cfg = config.services.time-machine;
in
{
  options.services.time-machine = {
    enable = lib.mkEnableOption "Enable Time Machine backups via Samba";
    storagePath = lib.mkOption {
      description = "The path where Time Machine backups will be stored.";
      default = "/srv/time-machine";
      type = types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    services.samba = {
      enable = true;
      settings.global."mdns name" = "mdns";
    };

    services.samba.settings.time-machine = {
      path = cfg.storagePath;
      "valid users" = "time-machine";
      public = "no";
      writeable = "yes";
      "force user" = "time-machine";
      "force group" = "time-machine";
      "guest ok" = "no";
      "fruit:time machine" = "yes";
      "fruit:time machine max size" = "4TB";
    };

    systemd.tmpfiles.rules = [ "d ${cfg.storagePath} 0755 time-machine time-machine" ];

    # Note: A password for the Samba time-machine user must be specified in ``/run/secrets/samba`.
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
  };
}
