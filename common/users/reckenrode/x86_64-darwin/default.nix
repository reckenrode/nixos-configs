{ config, lib, pkgs, ... }:

{
  imports = [
    ./applications.nix
    ./bear.nix
    ./fish.nix
    ./safari.nix
    ./ssh.nix
    ./things3.nix
    ./tower.nix
  ];
  
  home.packages = with pkgs; [
    coreutils
    trash_mac
  ];
}
