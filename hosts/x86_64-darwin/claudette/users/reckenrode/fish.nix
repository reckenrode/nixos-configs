{ ... }:

{
  programs.fish.loginShellInit = let
    secretivePath = "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
  in ''
    set -x DOTNET_CLI_TELEMETRY_OPTOUT 1
    set -x SSH_AUTH_SOCK ${secretivePath}
  '';
}
