{ pkgs, config, unstablePkgs, ... }:

{
  imports = [
    ./copyApplications.nix
    ./dock.nix
    ./finder.nix
    ./fish.nix
    ./gnupg.nix
    ./iterm2.nix
    ./keyboard.nix
    ./rust.nix
    ./safari.nix
    ./ui.nix
  ];

  home.packages =
    let
      inherit (pkgs) coreutils diffutils findutils gnutar less;
      inherit (pkgs.darwin) trash;
    in
    [
      coreutils
      diffutils
      findutils
      gnutar
      less
      trash
    ];
}
