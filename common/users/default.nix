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
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBDTegWuvc3zHmVOMqcY8TJrLzWwS3W3ro4v7/782WoUHge2SuvLCinb8yyD+SgIg2OyEz8q+iXwNUaFOa7sTM20="
    ];
  };
}
