{ config, lib, pkgs, flakePkgs, unstablePkgs, ... }:

{
  imports = [
    ./direnv.nix
    ./ffxiv.nix
    ./fonts.nix
    ./git.nix
    ./gnupg.nix
    ./secretive.nix
    ./ssh.nix
    ./vscode.nix
  ];
  
  home.packages =
    let
      inherit (flakePkgs) crossover netnewswire ocr-documents secretive verify-archive;
      inherit (pkgs) firefox-bin keybase openra openttd pngout steam;
      inherit (unstablePkgs) waifu2x-converter-cpp;
    [
      crossover
      firefox-bin
      keybase
      netnewswire
      ocr-documents
      openra
      openttd
      pngout
      secretive
      steam
      verify-archive
      waifu2x-converter-cpp
    ];
}
