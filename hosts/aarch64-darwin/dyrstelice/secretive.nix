{ flakePkgs, ... }:

let
  inherit (flakePkgs) secretive;
  
  secretAgent = "Contents/Library/LoginItems/SecretAgent.app/Contents/MacOS/SecretAgent";
in
{
  launchd.user.agents."SecretAgent".serviceConfig = rec {
    ProgramArguments = [
      "/bin/sh" "-c"
      ''
        /bin/wait4path ${secretive}/Applications/Secretive.app && \
          exec ${secretive}/Applications/Secretive.app/${secretAgent}
      ''
    ];
    KeepAlive = true;
    StandardErrorPath = StandardOutPath;
    StandardOutPath = "/Users/reckenrode/Library/Logs/SecretAgent.log";
  };

  environment.variables = {
    SSH_AUTH_SOCK = "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
  };
}
