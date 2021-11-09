{ pkgs, config, unstablePkgs, ... }:

{
  imports = [
    ./copyApplications.nix
    ./dock.nix
    ./finder.nix
    ./fish.nix
    ./gnupg.nix
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
      inherit (unstablePkgs.darwin) trash;
    in
    [
      coreutils
      findutils
      trash
    ];

  home.stateVersion = "21.05";
}
