{ lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.git ];

  programs.fish.enable = true;
}
