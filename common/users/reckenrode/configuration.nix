{ lib, pkgs, ... }:

{
  users.users.reckenrode = {
    description = "Randy Eckenrode";
    shell = pkgs.fish;
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    home = "/Users/reckenrode";
  } // lib.optionalAttrs pkgs.stdenv.isLinux {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM+aydjZ/Yb8onZQ5OLyXZr18NchFZQcZh8yNEuK/wOM"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBP7kafg9acMfZFFX6yj6t7HTdGg+KfFkXSopu5ZySCj"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOuTA92YDDZ8JrKj/qJia1uQ3qv0A8amt1+0AWT/i3bh6oVTrcbcbci9Bdbx1VAGS91IXgXooYfLlWdUk2mw4sQ="
    ];
  };
}
