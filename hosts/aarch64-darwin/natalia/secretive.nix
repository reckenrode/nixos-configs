{ flakePkgs, ... }:

let
  inherit (flakePkgs) secretive;

  secretAgent = "Contents/Library/LoginItems/SecretAgent.app/Contents/MacOS/SecretAgent";
in
{
  launchd.user.agents."SecretAgent" = {
    command = ''"/Applications/Nix Apps/Secretive.app/${secretAgent}"'';
    serviceConfig = rec {
      KeepAlive = true;
      StandardErrorPath = StandardOutPath;
      StandardOutPath = "/Users/reckenrode/Library/Logs/SecretAgent.log";
    };
  };

  environment.variables = {
    SSH_AUTH_SOCK = "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
  };
}
