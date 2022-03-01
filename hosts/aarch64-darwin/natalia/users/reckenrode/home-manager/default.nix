{ config, lib, pkgs, flakePkgs, x86_64, ... }:

{
  imports = [
    ./direnv.nix
    # ./ffxiv.nix - Disable until if/when the official Mac client is updated to use CrossOver 21
    ./fonts.nix
    ./git.nix
    ./secretive.nix
    ./ssh.nix
    ./vscode.nix
  ];

  home.packages =
    let
      inherit (x86_64.flakePkgs) crossover wonderdraft;
      inherit (x86_64.pkgs) openra steam tiled;
      inherit (x86_64.unstablePkgs) ffxiv;
      inherit (flakePkgs) daisydisk netnewswire ocr-documents secretive verify-archive;
      inherit (pkgs) firefox-bin keybase waifu2x-converter-cpp openttd terminal-notifier;
    in
    [
      crossover
      daisydisk
      ffxiv
      firefox-bin
      keybase
      netnewswire
      ocr-documents
      openra
      openttd
      secretive
      steam
      tiled
      verify-archive
      waifu2x-converter-cpp
      wonderdraft
    ];
}