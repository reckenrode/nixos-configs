# SPDX-License-Identifier: MIT

{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) types;

  kbfsfuse = "${lib.getBin pkgs.kbfs}/bin/kbfsfuse";
  logPath = "${config.home.homeDirectory}/Library/Logs";

  cfg = config.services;
in
{
  disabledModules = [ "services/kbfs.nix" ];

  options.services.kbfs = {
    enable = lib.mkEnableOption "Keybase File System";

    extraFlags = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "-label kbfs"
        "-mount-type normal"
      ];
      description = ''
        Additional flags to pass to the Keybase filesystem on launch.
      '';
    };
  };

  config = lib.mkIf cfg.kbfs.enable {
    home.packages = [ pkgs.kbfs ];

    launchd.agents.kbfs = {
      enable = true;
      config = {
        Program = kbfsfuse;
        ProgramArguments = [
          kbfsfuse
          "-log-file=${logPath}/keybase.kbfs.log"
        ] ++ cfg.kbfs.extraFlags;
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
