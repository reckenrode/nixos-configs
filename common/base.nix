{ lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.git ];

  programs.fish = {
    enable = true;
  } // lib.optionalAttrs (pkgs ? babelfish) {
    babelfishPackage = pkgs.babelfish;
    useBabelfish = true;
  };
}
