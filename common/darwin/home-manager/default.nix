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

  home.packages =
    let
      inherit (pkgs) coreutils findutils;
      inherit (flakePkgs) trash_mac;
    in
    [
      coreutils
      findutils
      trash_mac
    ];

  home.stateVersion = "21.05";
}
