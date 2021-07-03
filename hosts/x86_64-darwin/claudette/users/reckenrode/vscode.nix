{ pkgs, ... }:

{
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.Nix
        editorconfig.editorconfig
        pkgs.unstable.vscode-extensions.ionide.ionide-fsharp # FIXME: once 21.11 lands
        ms-dotnettools.csharp
      ];
      userSettings = {
        "FSharp.dotnetRoot" = "${pkgs.dotnet-sdk_5}";
        "editor.minimap.enabled" = false;
        "editor.roundedSelection" = false;
        "editor.rulers" = [ 100 ];
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "telemetry.enableTelemetry" = false;
        "window.titleBarStyle" = "native";
        "workbench.colorTheme" = "Default Light+";
      };
    };
}
