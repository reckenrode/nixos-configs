{ config, lib, pkgs, flakePkgs, unstablePkgs, x86_64, ... }:

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
      inherit (x86_64.flakePkgs) crossover;
      inherit (x86_64.pkgs) openra pngout steam;
      inherit (flakePkgs) daisydisk netnewswire ocr-documents secretive verify-archive;
      inherit (pkgs) firefox-bin openttd;
      inherit (unstablePkgs) keybase waifu2x-converter-cpp;
    in
    [
      crossover
      daisydisk
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
