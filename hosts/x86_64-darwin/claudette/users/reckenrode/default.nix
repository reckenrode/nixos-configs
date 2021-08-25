{ config, lib, pkgs, ... }:

{
  imports = [
    ./bear.nix
    ./direnv.nix
    ./ffxiv.nix
    ./fish.nix
    ./fonts.nix
    ./git.nix
    ./gnupg.nix
    ./ssh.nix
    ./vscode.nix
  ];
  
  home.packages = with pkgs; [
    crossover
    firefox-bin
    # jetbrains.ruby-mine
    netnewswire
    ocr-documents
    openra
    openttd
    # pathofexile
    pngout
    secretive
    steam
    # tiled
    verify-archive
    waifu2x-converter-cpp
  ];
}
