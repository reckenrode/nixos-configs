{ config, lib, pkgs, flakePkgs, ... }:

{
  imports = [
    ./git.nix
  ];

  home.packages =
    let
      inherit (pkgs) openssh steam;
      inherit (flakePkgs) verify-archive;
    in
    [
      openssh
      steam
      verify-archive
    ];
}
