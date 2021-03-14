{ config, lib, pkgs, modulesPath, ... }:

let
  args = {
    inherit lib pkgs modulesPath;
    config.services.coturn = config.services.coturn;
  };
  coturnModule = import (modulesPath + "/services/networking/coturn.nix") args;
  execStart = coturnModule.config.content.systemd.services.coturn.serviceConfig.ExecStart;
  configFile = lib.trivial.pipe execStart [
    (lib.strings.splitString " ")
    (lib.flip builtins.elemAt 2)
  ];
  runtimeConfigFile = "/run/turnserver/turnserver.conf";
in {
  options = {
    services.coturn.static-users-file = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = ''
        File containing a list of static users for coturn. The list must follow the format used in
        turnserver.conf.
      '';
      default = null;
    };
  };

  config = lib.mkIf (config.services.coturn ? static-users-file) {
    systemd.services.coturn.preStart = ''
      install -m 0600 -g turnserver -o turnserver ${configFile} ${runtimeConfigFile}
      cat ${config.services.coturn.static-users-file} >> ${runtimeConfigFile}
    '';
  
    systemd.services.coturn.serviceConfig.ExecStart = lib.mkOverride 0 ''
      ${pkgs.coturn}/bin/turnserver -c ${runtimeConfigFile}
    '';
  };
}
