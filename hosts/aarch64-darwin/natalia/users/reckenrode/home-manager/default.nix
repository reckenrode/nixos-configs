{ config, lib, pkgs, flakePkgs, unstablePkgs, x86_64, modulesPath, ... }:

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
      inherit (x86_64.flakePkgs) ffxiv wonderdraft;
      inherit (x86_64.pkgs) openra steam tiled;
      inherit (flakePkgs) daisydisk netnewswire ocr-documents verify-archive;
      inherit (pkgs) firefox-bin waifu2x-converter-cpp openttd terminal-notifier;

      crossover = x86_64.flakePkgs.crossover.override {
        iUnderstandThatReplacingMoltenVKAndDXVKIsNotSupportedByCodeWeaversAndWillNotBotherThemForSupport = true;
      };
    in
    [
      crossover
      daisydisk
      ffxiv
      firefox-bin
      netnewswire
      ocr-documents
      openra
      openttd
      steam
      tiled
      verify-archive
      waifu2x-converter-cpp
      wonderdraft
    ];

  services.keybase.enable = true;
  services.kbfs = {
    enable = true;
    extraFlags = [ "-mount-type=none" ];
  };
}
