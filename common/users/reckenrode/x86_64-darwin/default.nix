{ config, lib, pkgs, ... }:

{
  imports = [
    ./bear.nix
    ./fish.nix
    ./safari.nix
    ./ssh.nix
    ./things3.nix
    ./tower.nix
  ];
  
  home.packages = with pkgs; [
    trash_mac
  ];
}
