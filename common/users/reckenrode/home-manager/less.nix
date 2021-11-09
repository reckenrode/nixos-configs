{ config, ... }:

{
  home.sessionVariables = {
    LESSHISTFILE = "${config.xdg.dataHome}/less/history";
  };

  xdg.dataFile."less/.keep" = {
    recursive = true;
    text = "";
  };
}
