{ pkgs, ... }:

{
  imports = [
    ./copyApplications.nix
    ./dock.nix
    ./finder.nix
    ./fish.nix
    ./keyboard.nix
    ./safari.nix
    ./ui.nix
  ];

  home.packages = with pkgs; [
    coreutils
    trash_mac
  ];
}