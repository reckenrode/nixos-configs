{ pkgs, ... }:

{
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.Nix
        editorconfig.editorconfig
        pkgs.unstable.vscode-extensions.ionide.ionide-fsharp # FIXME: once 21.11 lands
      ];
      userSettings = {
        "editor.minimap.enabled" = false;
        "editor.roundedSelection" = false;
        "editor.rulers" = [ 100 ];
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "workbench.colorTheme" = "Default Light+";
        "window.titleBarStyle" = "native";
      };
    };
}
