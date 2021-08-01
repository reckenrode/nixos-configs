{ config, lib, pkgs, ... }:

{
  imports = [
    ./fish.nix
  ];
  
  home.packages = with pkgs; [
    openssh
    steam
    verify-archive
  ];
}
