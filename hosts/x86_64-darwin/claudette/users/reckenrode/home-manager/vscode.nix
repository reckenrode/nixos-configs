{ lib, pkgs, unstablePkgs, ... }:

let
  xcodePath = "/Applications/Xcode.app";
  lldbFramework = "${xcodePath}/Contents/SharedFrameworks/LLDB.framework";
  debugserver = "${lldbFramework}/Versions/A/Resources/debugserver";

  direnv = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "cab404";
      name = "vscode-direnv";
      version = "1.0.0";
      sha256 = "sha256-+nLH+T9v6TQCqKZw6HPN/ZevQ65FVm2SAo2V9RecM3Y=";
    };
  };

  hledgerExtension = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "mark-hansen";
      name = "hledger-vscode";
      version = "0.0.7";
      sha256 = "sha256-whQaXrzDhVbDRlT7uCK5ORkxT4f1X4cWwSS1YOvL5xI=";
    };
  };

  hledger-vscode = loadAfter [ "cab404.vscode-direnv" ] hledgerExtension;
  rust-analyzer = loadAfter [ "cab404.vscode-direnv" ] pkgs.vscode-extensions.matklad.rust-analyzer;

  # Work around the lack of extension ordering in VS Code
  # See: https://github.com/Microsoft/vscode/issues/57481#issuecomment-910883638
  loadAfter = deps: pkg: pkg.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs or [] ++ [ pkgs.jq pkgs.moreutils ];

    preInstall = ''
      ${old.preInstall or ""}
      jq '.extensionDependencies |= . + $deps' \
      --argjson deps ${lib.escapeShellArg (builtins.toJSON deps)} \
      package.json | sponge package.json
    '';
  });
in
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
      direnv
      editorconfig.editorconfig
      hledger-vscode
      rust-analyzer
      unstablePkgs.vscode-extensions.vadimcn.vscode-lldb
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
