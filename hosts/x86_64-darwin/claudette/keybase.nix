{ pkgs, ... }:

{
  launchd.user.agents."keybase".serviceConfig = rec {
    ProgramArguments = [
      "/bin/sh" "-c"
      ''
        /bin/wait4path ${pkgs.keybase}/bin/keybase && \
          exec ${pkgs.keybase}/bin/keybase --log-file=/Users/reckenrode/Library/Logs/keybase.service.log service
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
        /bin/wait4path ${pkgs.kbfs}/bin/kbfsfuse && \
          exec ${pkgs.kbfs}/bin/kbfsfuse -log-file=/Users/reckenrode/Library/Logs/keybase.kbfs.log -mount-type=none
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
