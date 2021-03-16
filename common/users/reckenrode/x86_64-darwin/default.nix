{ config, lib, pkgs, ... }:

{
  imports = [
    ./applications.nix
    ./bear.nix
    ./dock.nix
    ./finder.nix
    ./fish.nix
    ./keyboard.nix
    ./safari.nix
    ./ssh.nix
    ./things3.nix
    ./tower.nix
    ./ui.nix
  ];
  
  home.packages = with pkgs; [
    coreutils
    trash_mac
  ];

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
  };
}
