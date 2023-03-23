# SPDX-License-Identifier: MIT

{ pkgs, lib, config, ... }:

let
  copyOf = pkg: pkg.overrideAttrs (old: {
    installPhase = ''
      $DRY_RUN_CMD install -D -m 444 fonts/otf/* -t $out/share/fonts/otf
    '';
  });

  mkSshConfig = { host ? hostname, hostname, port ? 562, user ? "reckenrode", identityFile ? null }: {
    name = host;
    value = {
      inherit hostname port user;
    } // lib.optionalAttrs (identityFile != null) {
      identityFile = [ "${identityFile}" ];
      identitiesOnly = true;
    };
  };

  mark-hansen.hledger-vscode = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "mark-hansen";
      name = "hledger-vscode";
      version = "0.0.7";
      sha256 = "sha256-whQaXrzDhVbDRlT7uCK5ORkxT4f1X4cWwSS1YOvL5xI=";
    };
  };
in
{
  home = {
    username = "reckenrode";
    homeDirectory = "/Users/reckenrode";
    stateVersion = "22.11";
  };

  home.packages = lib.attrValues {
    inherit (pkgs) ripgrep waifu2x-converter-cpp;
    inherit (pkgs.darwin) trash;
  } ++ map copyOf [ pkgs.alegreya pkgs.alegreya-sans ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.fish.enable = true;

  programs.git = {
    enable = true;
    userEmail = "randy@largeandhighquality.com";
    userName = "Randy Eckenrode";
    signing = {
      key = "01D754863A6D64EAAC770D26FBF19A982CCE0048";
      signByDefault = true;
    };
    extraConfig = {
      init = { defaultBranch = "main"; };
      credential.helper = "${lib.getBin pkgs.git}/bin/git-credential-osxkeychain";
    };
  };

  programs.gpg.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig =
      let
        secretiveAgentSocket = config.home.homeDirectory
          + "/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
      in
      "IdentityAgent ${secretiveAgentSocket}";
    matchBlocks = builtins.listToAttrs (map mkSshConfig [
      { hostname = "github.com"; port = 22; }
      { hostname = "imac.local"; port = 22; }
      { hostname = "largeandhighquality.com"; }
      { hostname = "khloe.infra.largeandhighquality.com"; }
      { hostname = "meteion.infra.largeandhighquality.com"; }
      { hostname = "zhloe.infra.largeandhighquality.com"; }
    ]);
  };

  programs.vscode = {
    enable = true;
    extensions = [
      pkgs.vscode-extensions.editorconfig.editorconfig
      mark-hansen.hledger-vscode
    ];
    userSettings = {
      "editor.bracketPairColorization.enabled" = true;
      "editor.fontFamily" = "SF Mono, Menlo, Monaco, 'Courier New', monospace";
      "editor.guides.bracketPairs" = "active";
      "editor.inlayHints.enabled" = "off";
      "editor.minimap.enabled" = false;
      "editor.roundedSelection" = false;
      "editor.rulers" = [ 100 ];
      "editor.semanticTokenColorCustomizations" = {
        "[Default Light+]" = {
          "enabled" = true;
          "rules" = {
            "*.mutable" = {
              # "foreground" = "#FF0000";
              "fontStyle" = "underline";
            };
            "*.disposable" = {
              # "foreground" = "#ff8b2c";
              "fontStyle" = "bold";
            };
          };
        };
      };
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "explorer.sortOrder" = "mixed";
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      "git.path" = "${lib.getBin pkgs.git}/bin/git";
      "telemetry.enableTelemetry" = false;
      "telemetry.telemetryLevel" = "off";
      "update.mode" = "none";
      "window.titleBarStyle" = "native";
      "workbench.editor.tabCloseButton" = "left";
      "workbench.colorTheme" = "Default Light+";
#        "lldb.adapterEnv" = {
#          "LLDB_DEBUGSERVER_PATH" = debugserver;
#        };
    };
  };

  services.keybase.enable = true;

  services.kbfs = {
    enable = true;
    extraFlags = [ "-mount-type=none" ];
  };

  xdg.enable = true;
  xdg.userDirs.enable = true;
}
