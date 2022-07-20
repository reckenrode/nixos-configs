{ lib, pkgs, ... }:

let
  nvd = "${lib.getBin pkgs.nvd}/bin/nvd";
  find = "${lib.getBin pkgs.findutils}/bin/find";
  readlink = "${lib.getBin pkgs.coreutils}/bin/readlink";
in
{
  system.activationScripts.postActivation.text = ''
    old_generation=$(${find} /nix/var/nix/profiles -lname $(${readlink} -f /run/current-system))
    new_generation=$(${find} /nix/var/nix/profiles -lname $(${readlink} -f "$systemConfig"))
    ${nvd} diff "$old_generation" "$new_generation"
  '';
}
