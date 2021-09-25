{ pkgs, flakePkgs, ... }:

{
  imports = [
    ./copyApplications.nix
    ./dock.nix
    ./finder.nix
    ./fish.nix
    ./keyboard.nix
    ./kitty.nix
#    ./safari.nix
    ./ui.nix
  ];

  home.packages = with pkgs; [
    coreutils
    findutils
    flakePkgs.trash_mac
  ];

  home.stateVersion = "21.05";
}
