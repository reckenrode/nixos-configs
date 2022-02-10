{ config, lib, pkgs, ... }:

let
  patch = ./touchid.patch;
in
{
  options.security.pam.enableSudoTouchIdAuth = lib.mkEnableOption "Enable Touch ID PAM module for sudo.";
  config.system.activationScripts.etc.text = ''
    ${if config.security.pam.enableSudoTouchIdAuth
      then ''
        patch --dry-run --forward -p1 -d / < ${patch} &> /dev/null \
          && echo "patching /etc/pam.d/sudo to enable Touch ID" \
          && patch -p1 -d / -V never &> /dev/null < ${patch}
      ''
      else ''
        patch --dry-run --reverse -p1 -d / < ${patch} &> /dev/null \
          && echo "patching /etc/pam.d/sudo to disable Touch ID" \
          && patch --reverse -p1 -d / -V never &> /dev/null < ${patch}
      ''}
  '';
}
