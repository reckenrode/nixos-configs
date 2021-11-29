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
      inherit (x86_64.pkgs) openra steam;
      inherit (x86_64.unstablePkgs) pngout;
      inherit (flakePkgs) daisydisk netnewswire ocr-documents secretive verify-archive;
      inherit (pkgs) firefox-bin openttd terminal-notifier;
      inherit (unstablePkgs) keybase waifu2x-converter-cpp;

      gomuks = pkgs.gomuks.overrideAttrs (old: {
        postInstall = ''
          cp -r ${
            pkgs.makeDesktopItem {
              name = "net.maunium.gomuks.desktop";
              exec = "@out@/bin/gomuks";
              terminal = "true";
              desktopName = "Gomuks";
              genericName = "Matrix client";
              categories = "Network;Chat";
              comment = old.meta.description;
            }
          }/* $out/
          substituteAllInPlace $out/share/applications/*
          wrapProgram $out/bin/gomuks \
            --prefix PATH : "${lib.makeBinPath [ terminal-notifier ]}"
        '';
      });
    in
    [
      crossover
      daisydisk
      firefox-bin
      gomuks
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
      # weechat
    ];
}
