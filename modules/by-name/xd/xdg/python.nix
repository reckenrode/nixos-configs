# SPDX-License-Identifier: MIT

{ config, lib, inputs, ... }:

{
  config = lib.mkIf config.xdg.enable {
    home.sessionVariables.PYTHONSTARTUP = ./pythonstartup.py;
  };
}
