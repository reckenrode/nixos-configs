# SPDX-License-Identifier: MIT

{ config, lib, ... }:

let
  inherit (lib) types;

  cfg = config.services.coturn;
  runtimeConfigFile = "/run/coturn/turnserver.cfg";
in
{
  options = {
    services.coturn.static-users-file = lib.mkOption {
      type = types.nullOr types.path;
      description = ''
        File containing a list of static users for coturn, which must follow the format used in
        turnserver.conf.
      '';
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.coturn.preStart = lib.optionalString (cfg.static-users-file != null)
      "cat ${cfg.static-users-file} >> ${runtimeConfigFile}";
  };
}
