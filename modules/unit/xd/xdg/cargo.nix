# SPDX-License-Identifier: MIT

{ config, lib, ... }:

{
  config = lib.mkIf config.xdg.enable {
    home.sessionVariables = { CARGO_HOME = "${config.xdg.cacheHome}/cargo"; };
  };
}
