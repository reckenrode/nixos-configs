# SPDX-License-Identifier: MIT

{ config, lib, ... }:

{
  config = lib.mkIf config.xdg.enable {
    home.sessionVariables.DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
  };
}
