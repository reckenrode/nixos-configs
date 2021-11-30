{ pkgs, config, unstablePkgs, ... }:

{
  imports = [
    ./copyApplications.nix
    ./dock.nix
    ./finder.nix
    ./fish.nix
    ./gnupg.nix
    ./keyboard.nix
    ./rust.nix
    ./safari.nix
    ./ui.nix
  ];

  home.packages =
    let
      inherit (pkgs) coreutils diffutils findutils gnutar less;
      inherit (pkgs.darwin) trash;

      iterm2 = pkgs.callPackage unstablePkgs.iterm2.override {};
    in
    [
      coreutils
      diffutils
      findutils
      gnutar
      less
      trash
      iterm2
    ];
}
