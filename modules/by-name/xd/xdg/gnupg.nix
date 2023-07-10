# SPDX-License-Identifier: MIT

{ config, lib, ... }:
{
  config = lib.mkIf (config.xdg.enable && config.programs.gpg.enable) {
    programs.gpg.homedir = "${config.xdg.dataHome}/gnupg";
  };
}
