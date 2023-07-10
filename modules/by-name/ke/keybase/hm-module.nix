# SPDX-License-Identifier: MIT

{ pkgs, lib, config, ...}:

let
  inherit (lib) types;

  keybase = "${lib.getBin pkgs.keybase}/bin/keybase";
  logPath = "${config.home.homeDirectory}/Library/Logs";

  cfg = config.services;
in
{
  disabledModules = [ "services/keybase.nix" ];

  options.services.keybase.enable = lib.mkEnableOption "Keybase";

  config = lib.mkIf cfg.keybase.enable {
    home.packages = [ pkgs.keybase ];

    launchd.agents.keybase = {
      enable = true;
      config = {
        Program = keybase;
        ProgramArguments = [ keybase "--log-file=${logPath}/keybase.service.log" "service" ];
        EnvironmentVariables = {
          KEYBASE_LABEL = "keybase.service";
          KEYBASE_SERVICE_TYPE = "launchd";
          KEYBASE_RUN_MODE = "prod";
        };
        KeepAlive = true;
        StandardErrorPath = "${logPath}/keybase.start.log";
        StandardOutPath = "${logPath}/keybase.start.log";
        WorkingDirectory = "/tmp";
      };
    };
  };
}
