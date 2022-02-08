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
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNEN6b+msDHGPwNNPZS2KGW77Alc9zU8Tislj/PxV7rO8Vkz2FhS9rjjd8ZQlSnn+YgqFuJamNEyR78WgclgKsM="
    ];
  };
}
