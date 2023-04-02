# SPDX-License-Identifier: MIT

{ config, lib, ... }:

{
  config = lib.mkIf config.programs.gpg.enable {
    programs.fish.interactiveShellInit = ''
      set -gx GPG_TTY $(tty)
    '';
  };
}
