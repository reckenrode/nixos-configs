# SPDX-License-Identifier: MIT

{ lib, config, ... }:

{
  config = lib.mkIf config.programs.gpg.enable {
    programs.fish.interactiveShellInit = ''
      set -gx GPG_TTY $(tty)
    '';
  };
}
