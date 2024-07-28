# SPDX-License-Identifier: MIT

{
  lib,
  config,
  pkgs,
  ...
}:

{
  config = lib.mkIf (config.programs.gpg.enable && pkgs.stdenv.isDarwin) {
    home.activation = {
      cleanUpGpgAgent = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${lib.getBin pkgs.gnupg}/bin/gpgconf --kill gpg-agent
      '';
    };

    home.file."${config.programs.gpg.homedir}/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    '';
  };
}
