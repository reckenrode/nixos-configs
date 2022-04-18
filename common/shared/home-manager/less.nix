{ config, ... }:

let
  lessStateDir = "${config.xdg.stateHome}/less";
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
