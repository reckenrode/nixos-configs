# SPDX-License-Identifier: MIT

{
  lib,
  config,
  ...
}:

{
  config = lib.mkIf config.xdg.enable { home.sessionVariables.PYTHONSTARTUP = ./pythonstartup.py; };
}
