{ config, lib, pkgs, ... }:

{
  imports = [
    ./bear.nix
    ./direnv.nix
    ./fish.nix
    ./fonts.nix
    ./git.nix
    ./gnupg.nix
    ./ssh.nix
    ./vscode.nix
  ];

  home.file.".local/bin/ocr-documents" = {
    executable = true;
    source = pkgs.substituteAll {
      src = ./ocr-documents;
      inherit (pkgs) coreutils fish gawk imagemagick7 poppler_utils tesseract4;
    };
  };
  
  home.packages = with pkgs; [
    crossover
    finalfantasyxiv
    firefox-bin
    # jetbrains.ruby-mine
    netnewswire
    openra
    openttd
    # pathofexile
    iterm2
    pngout
    secretive
    steam
    # tiled
    waifu2x-converter-cpp
  ];
}
