{ pkgs, config, flakePkgs, ... }:

{
  imports = [
    ./copyApplications.nix
    ./dock.nix
    ./finder.nix
    ./fish.nix
    ./keyboard.nix
    ./kitty.nix
    ./less.nix
    ./rust.nix
    ./safari.nix
    ./ui.nix
    ./xdg.nix
  ];

  home.packages = with pkgs; [
    coreutils
    findutils
    flakePkgs.trash_mac
  ];

  home.stateVersion = "21.05";
}
