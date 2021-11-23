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
  ];

  home.packages =
    let
      inherit (pkgs) coreutils diffutils findutils less;
      inherit (unstablePkgs.darwin) trash;
    in
    [
      coreutils
      diffutils
      findutils
      less
      trash
    ];

  home.stateVersion = "21.05";
}
