# SPDX-License-Identifier: MIT

{ config, lib, ... }:

let
  bashStateDir = "${config.xdg.stateHome}/bash";
in
{
  config = lib.mkIf config.xdg.enable {
    home.sessionVariables.HISTFILE = "${bashStateDir}/bash_history";

    home.file."${bashStateDir}/.keep" = {
      recursive = true;
      text = "";
    };
  };
}
