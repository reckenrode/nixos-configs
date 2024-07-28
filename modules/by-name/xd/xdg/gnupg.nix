# SPDX-License-Identifier: MIT

{ lib, config, ... }:

{
  config = lib.mkIf (config.xdg.enable && config.programs.gpg.enable) {
    programs.gpg.homedir = "${config.xdg.dataHome}/gnupg";
  };
}
