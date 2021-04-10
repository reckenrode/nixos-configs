{ config, lib, pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./git.nix
    ./gnupg.nix
  ];

  home.file.".local/bin/ocr-documents" = {
    executable = true;
    source = pkgs.substituteAll {
      src = ./ocr-documents;
      inherit (pkgs) coreutils fish gawk imagemagick7 poppler_utils tesseract4;
    };
  };
  
  home.packages = with pkgs; [
    finalfantasyxiv
    firefox-bin
    jetbrains.ruby-mine
    netnewswire
    openttd
    pathofexile
    pngout
    secretive
    steam
    tiled
    vscode
    waifu2x-converter-cpp
  ];
}
