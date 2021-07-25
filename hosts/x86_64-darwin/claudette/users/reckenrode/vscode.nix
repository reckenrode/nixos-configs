{ pkgs, ... }:

let
  commandLineTools = "/Library/Developer/CommandLineTools";
  lldbFramework = "${commandLineTools}/Library/PrivateFrameworks/LLDB.framework";
  debugserver = "${lldbFramework}/Versions/A/Resources/debugserver";
in {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
      editorconfig.editorconfig
      pkgs.unstable.vscode-extensions.ionide.ionide-fsharp # FIXME: once 21.11 lands
      ms-dotnettools.csharp
      rubymaniac.vscode-direnv
      pkgs.unstable.vscode-extensions.matklad.rust-analyzer
      pkgs.vscode-lldb.vscode-extensions.vadimcn.vscode-lldb
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
      "git.path" = "${pkgs.git}/bin/git";
      "telemetry.enableTelemetry" = false;
      "terminal.integrated.env.osx" = {
        # Put Git first to prevent VS Code from finding it in /usr/bin and triggering annoying
        # command-line tools installation dialogs.
        "PATH" = "${pkgs.git}/bin:\${env:PATH}:${pkgs.dotnet-sdk_5}";
      };
      "update.mode" = "none";
      "window.titleBarStyle" = "native";
      "workbench.editor.tabCloseButton" = "left";
      "workbench.colorTheme" = "Default Light+";
      "lldb.adapterEnv" = {
        "LLDB_DEBUGSERVER_PATH" = debugserver;
      };
    };
  };
}
