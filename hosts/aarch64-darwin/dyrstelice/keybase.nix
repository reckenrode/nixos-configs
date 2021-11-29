{ pkgs, ... }:

let
  inherit (pkgs) keybase kbfs;
in
{
  launchd.user.agents."keybase".serviceConfig = rec {
    ProgramArguments = [
      "/bin/sh" "-c"
      ''
        /bin/wait4path ${keybase}/bin/keybase && \
          exec ${keybase}/bin/keybase --log-file=/Users/reckenrode/Library/Logs/keybase.service.log service
      ''
    ];
    EnvironmentVariables = {
      KEYBASE_LABEL = "keybase.service";
      KEYBASE_SERVICE_TYPE = "launchd";
      KEYBASE_RUN_MODE = "prod";
    };
    KeepAlive = true;
    StandardErrorPath = StandardOutPath;
    StandardOutPath = "/Users/reckenrode/Library/Logs/keybase.start.log";
    WorkingDirectory = "/tmp";
  };

  launchd.user.agents."kbfs".serviceConfig = rec {
    ProgramArguments = [
      "/bin/sh" "-c"
      ''
        /bin/wait4path ${kbfs}/bin/kbfsfuse && \
          exec ${kbfs}/bin/kbfsfuse -log-file=/Users/reckenrode/Library/Logs/keybase.kbfs.log -mount-type=none
      ''
    ];
    EnvironmentVariables = {
      KEYBASE_LABEL = "keybase.kbfs";
      KEYBASE_SERVICE_TYPE = "launchd";
      KEYBASE_RUN_MODE = "prod";
    };
    KeepAlive = true;
    StandardErrorPath = StandardOutPath;
    StandardOutPath = "/Users/reckenrode/Library/Logs/kbfs.start.log";
    WorkingDirectory = "/tmp";
  };
}
