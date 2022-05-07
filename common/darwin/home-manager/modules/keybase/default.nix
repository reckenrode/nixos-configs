{ pkgs
, config
, lib
, ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.services.keybase;
  keybase = "${pkgs.keybase}/bin/keybase";
  logPath = "${config.home.homeDirectory}/Library/Logs";
in
{
  disabledModules = [ "services/keybase.nix" ];

  options.services.keybase.enable = mkEnableOption "Keybase";

  config = mkIf cfg.enable {
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
