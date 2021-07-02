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
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBD10tzdnD0GW/gdKC6yKjc2tbBnlhgsbiK/JZLSwWNMYcQ4QrFp1+MUjBfiy8Ey00xrN9YcCkuTIBBcQ+niQYFg="
    ];
  };
}
