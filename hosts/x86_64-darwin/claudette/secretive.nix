{ flakePkgs, ... }:

let
  secretAgent = "Contents/Library/LoginItems/SecretAgent.app/Contents/MacOS/SecretAgent";
in
{
  launchd.user.agents."SecretAgent".serviceConfig = rec {
    ProgramArguments = [
      "/bin/sh" "-c"
      ''
        /bin/wait4path ${flakePkgs.secretive}/Applications/Secretive.app && \
          exec ${flakePkgs.secretive}/Applications/Secretive.app/${secretAgent}
      ''
    ];
    KeepAlive = true;
    StandardErrorPath = StandardOutPath;
    StandardOutPath = "/Users/reckenrode/Library/Logs/SecretAgent.log";
  };
}
