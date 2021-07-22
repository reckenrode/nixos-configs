{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
      editorconfig.editorconfig
      pkgs.unstable.vscode-extensions.ionide.ionide-fsharp # FIXME: once 21.11 lands
      ms-dotnettools.csharp
      rubymaniac.vscode-direnv
      pkgs.unstable.vscode-extensions.matklad.rust-analyzer
    ];
    userSettings = {
      "FSharp.dotnetRoot" = "${pkgs.dotnet-sdk_5}";
      "csharp.suppressDotnetInstallWarning" = true;
      "editor.fontFamily" = "SF Mono, Menlo, Monaco, 'Courier New', monospace";
      "editor.minimap.enabled" = false;
      "editor.roundedSelection" = false;
      "editor.rulers" = [ 100 ];
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      "telemetry.enableTelemetry" = false;
      "terminal.integrated.env.osx" = { "PATH" = "\${env:PATH}:${pkgs.dotnet-sdk_5}"; };
      "update.mode" = "none";
      "window.titleBarStyle" = "native";
      "workbench.editor.tabCloseButton" = "left";
      "workbench.colorTheme" = "Default Light+";
    };
  };
}
