{ pkgs, config, unstablePkgs, ... }:

{
  imports = [
    ./copyApplications.nix
    ./fish.nix
    ./gnupg.nix
    ./rust.nix
    ./vscode.nix
  ];

  home.packages =
    let
      inherit (pkgs) bzip2 curl coreutils diffutils findutils gzip gnutar less time unzip zip zstd;
      inherit (pkgs.darwin) trash;
    in
    [
      bzip2
      coreutils
      curl
      diffutils
      findutils
      gnutar
      gzip
      less
      time
      trash
      unzip
      zip
      zstd
    ];
}
