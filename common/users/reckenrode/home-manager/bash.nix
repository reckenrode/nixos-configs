{ config, ... }:

let
  bashStateDir = "${config.home.sessionVariables.XDG_STATE_HOME}/bash";
in
{
  home.sessionVariables.HISTFILE = "${bashStateDir}/bash_history";

  home.file."${bashStateDir}/.keep" = {
    recursive = true;
    text = "";
  };
}
