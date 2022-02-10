{ config, pkgs, ... }:

{
  programs.vscode.package = pkgs.vscode.overrideAttrs (old:
    let
      homeDir = "${config.home.homeDirectory}/Applications/Home Manager Apps";
    in
    {
      fixupPhase = ''
        echo Home Manager apps directory references fixup
        escape() {
          echo $1 | sed 's|/|\\\/|g'
        }
        appDir=$out/Applications
        homeDir=$(escape "${homeDir}")

        find $out -type l -print0 | while read -d $'\0' -r link; do
          target=$(realpath -- "$link" && echo .)
          target=''${target%??}
          if [[ $(readlink -- "$link") =~ ^/ && $target =~ ^$appDir ]]; then
            newTarget=$(echo "$target" | sed "s/^$(escape "$appDir")/$homeDir/" && echo .)
            newTarget=''${newTarget%??}
            rm "$link"
            ln -s "$newTarget" "$link"
          fi
        done
      '';
    });
}
