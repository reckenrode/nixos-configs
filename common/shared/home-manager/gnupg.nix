{ config, ... }:

{
  programs.fish.interactiveShellInit = ''
    set -gx GPG_TTY (tty)
  '';

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };
}
