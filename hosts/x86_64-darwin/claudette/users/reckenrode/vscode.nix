{ pkgs, ... }:

let
  xcodePath = "/Applications/Xcode.app";
  lldbFramework = "${xcodePath}/Contents/SharedFrameworks/LLDB.framework";
  debugserver = "${lldbFramework}/Versions/A/Resources/debugserver";
in {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
      editorconfig.editorconfig
      rubymaniac.vscode-direnv
      pkgs.unstable.vscode-extensions.matklad.rust-analyzer
      pkgs.vscode-lldb.vscode-extensions.vadimcn.vscode-lldb
    ];
    userSettings = {
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
