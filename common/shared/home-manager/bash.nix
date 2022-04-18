{ config, ... }:

let
  bashStateDir = "${config.xdg.stateHome}/bash";
in
{
  home.sessionVariables.HISTFILE = "${bashStateDir}/bash_history";

  home.file."${bashStateDir}/.keep" = {
    recursive = true;
    text = "";
  };
}
