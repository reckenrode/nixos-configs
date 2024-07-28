# SPDX-License-Identifier: MIT

{ lib, config, ... }:

{
  config = lib.mkIf config.xdg.enable {
    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.cacheHome}/cargo";
    };
  };
}
