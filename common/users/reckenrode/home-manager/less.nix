{ config, ... }:

let
  lessStateDir = "${config.home.sessionVariables.XDG_STATE_HOME}/less";
in
{
  home.sessionVariables = {
    LESSHISTFILE = "${lessStateDir}/history";
  };

  home.file."${lessStateDir}/.keep" = {
    recursive = true;
    text = "";
  };
}
