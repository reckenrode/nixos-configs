{ pkgs, ... }:

{
  imports = [
    ./copyApplications.nix
    ./dock.nix
    ./finder.nix
    ./fish.nix
    ./keyboard.nix
    ./kitty.nix
    ./safari.nix
    ./ui.nix
  ];

  home.packages = with pkgs; [
    coreutils
    findutils
    trash_mac
  ];
}
