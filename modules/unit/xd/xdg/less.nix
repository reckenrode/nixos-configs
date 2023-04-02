# SPDX-License-Identifier: MIT

{ config, lib, ... }:

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
