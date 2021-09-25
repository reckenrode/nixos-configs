{ lib, pkgs, ... }:

{
  imports = [
    ./nix-flakes.nix
  ];

  environment.systemPackages = [ pkgs.git ];

  programs.fish.enable = true;
}
