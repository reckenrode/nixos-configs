{ pkgs, lib, config, ... }:

{
  home.activation = {
    cleanUpGpgAgent = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.gnupg}/bin/gpgconf --kill gpg-agent
     '';
   };

  home.file."${config.programs.gpg.homedir}/gpg-agent.conf".text = ''
    pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
  '';

  programs.fish.interactiveShellInit = ''
    set -gx GPG_TTY (tty)
  '';

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };
}
