{ config, lib, pkgs, modulesPath, ... }:

let
  inherit (lib) types;

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

  config = lib.mkIf (config.services.coturn ? static-users-file) {
    systemd.services.coturn.preStart = ''
      cat ${config.services.coturn.static-users-file} >> ${runtimeConfigFile}
    '';
  };
}
