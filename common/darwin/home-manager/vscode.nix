{ config, pkgs, ... }:

{
  programs.vscode.package = pkgs.vscode.overrideAttrs (old:
    let
      app = "${config.home.homeDirectory}/Applications/Home Manager Apps/Visual Studio Code.app";
    in
      {
        installPhase = ''
          ${old.installPhase}
          rm "$out/bin/code"
          ln -s "${app}/Contents/Resources/app/bin/code" "$out/bin/code"
        '';
      });
}
