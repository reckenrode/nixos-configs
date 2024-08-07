# SPDX-License-Identifier: MIT

{ lib, config, ... }:

let
  lessStateDir = "${config.xdg.stateHome}/less";
in
{
  config = lib.mkIf config.xdg.enable {
    home.sessionVariables = {
      LESSHISTFILE = "${lessStateDir}/history";
    };

    home.file."${lessStateDir}/.keep" = {
      recursive = true;
      text = "";
    };
  };
}
