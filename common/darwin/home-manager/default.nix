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
      inherit (pkgs) bzip2 coreutils diffutils findutils gzip gnutar less time unzip zip;
      inherit (pkgs.darwin) trash;
    in
    [
      bzip2
      coreutils
      diffutils
      findutils
      gnutar
      gzip
      less
      time
      trash
      unzip
      zip
    ];
}
