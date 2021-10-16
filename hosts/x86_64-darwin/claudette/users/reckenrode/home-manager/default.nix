{ config, lib, pkgs, flakePkgs, unstablePkgs, ... }:

{
  imports = [
    ./direnv.nix
    ./ffxiv.nix
    ./fish.nix
    ./fonts.nix
    ./git.nix
    ./gnupg.nix
    ./ssh.nix
    ./vscode.nix
  ];
  
  home.packages = with pkgs; with flakePkgs; [
    crossover
    firefox-bin
    netnewswire
    ocr-documents
    openra
    openttd
    pngout
    secretive
    steam
    verify-archive
    unstablePkgs.waifu2x-converter-cpp
  ];
}
