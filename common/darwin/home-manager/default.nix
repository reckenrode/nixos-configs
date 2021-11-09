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
    ./rust.nix
    ./safari.nix
    ./ui.nix
    ./xdg.nix
  ];

  home.packages =
    let
      inherit (pkgs) coreutils findutils less;
      inherit (unstablePkgs.darwin) trash;
    in
    [
      coreutils
      findutils
      less
      trash
    ];

  home.stateVersion = "21.05";
}
