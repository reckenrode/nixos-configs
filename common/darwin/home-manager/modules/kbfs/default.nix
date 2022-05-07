{ pkgs
, config
, lib
, modulesPath
, ...
}:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.services.kbfs;
  kbfsfuse = "${pkgs.kbfs}/bin/kbfsfuse";
  logPath = "${config.home.homeDirectory}/Library/Logs";
in
{
  disabledModules = [ "services/kbfs.nix" ];

  options.services.kbfs = {
    enable = mkEnableOption "Keybase File System";

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "-label kbfs" "-mount-type normal" ];
      description = ''
        Additional flags to pass to the Keybase filesystem on launch.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.kbfs ];

    launchd.agents.kbfs = {
      enable = true;
      config = {
        Program = kbfsfuse;
        ProgramArguments = [ kbfsfuse "-log-file=${logPath}/keybase.kbfs.log" ] ++ cfg.extraFlags;
        EnvironmentVariables = {
          KEYBASE_LABEL = "keybase.kbfs";
          KEYBASE_SERVICE_TYPE = "launchd";
          KEYBASE_RUN_MODE = "prod";
        };
        KeepAlive = true;
        StandardErrorPath = "${logPath}/kbfs.start.log";
        StandardOutPath = "${logPath}/kbfs.start.log";
        WorkingDirectory = "/tmp";
      };
    };

    services.keybase.enable = true;
  };
}
