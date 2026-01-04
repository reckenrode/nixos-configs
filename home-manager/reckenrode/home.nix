# SPDX-License-Identifier: MIT

{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  copyOf =
    pkg:
    pkg.overrideAttrs (old: {
      installPhase = ''
        $DRY_RUN_CMD install -D -m 444 fonts/otf/* -t $out/share/fonts/otf
      '';
    });

  mkSshConfig =
    {
      host ? hostname,
      hostname,
      port ? 562,
      user ? "reckenrode",
      identityAgent,
    }:
    {
      name = host;
      value = {
        inherit hostname port user;
        extraOptions.IdentityAgent = identityAgent;
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
    stateVersion = "25.11";
  };

  home.packages =
    lib.attrValues {
      inherit (pkgs) btop ripgrep waifu2x-converter-cpp;
      inherit (pkgs.darwin) trash;
    }
    ++ map copyOf [
      pkgs.alegreya
      pkgs.alegreya-sans
    ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.fish.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "randy@largeandhighquality.com";
        name  = "Randy Eckenrode";
      };
      init.defaultBranch = "main";
      credential.helper = "${lib.getBin pkgs.git}/bin/git-credential-osxkeychain";
      url."git@github.com:".pushInsteadOf = "https://github.com/";
    };
    signing = {
      key = "01D754863A6D64EAAC770D26FBF19A982CCE0048";
      signByDefault = true;
    };
  };

  programs.gpg.enable = true;

  home.shellAliases = {
    # Work around https://github.com/martinvonz/jj/issues/4508
    jj = "RAYON_NUM_THREADS=4 command jj";
  };

  programs.jujutsu = {
    enable = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.jujutsu;
    settings = {
      ui.diff-editor = ":builtin";
      user = {
        name = "Randy Eckenrode";
        email = "randy@largeandhighquality.com";
      };
      signing = {
        backend = "gpg";
        key = "01D754863A6D64EAAC770D26FBF19A982CCE0048";
        signing.behavior = "own";
      };
    };
  };

  programs.neovim.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks =
      let
        secretive = "~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
        _1password = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
      in
      builtins.listToAttrs (
        map mkSshConfig [
          {
            hostname = "github.com";
            port = 22;
            identityAgent = secretive;
          }
          {
            hostname = "imac.local";
            port = 22;
            identityAgent = secretive;
          }
          {
            hostname = "largeandhighquality.com";
            identityAgent = secretive;
          }
          {
            hostname = "khloe.infra.largeandhighquality.com";
            identityAgent = secretive;
          }
          {
            hostname = "meteion.infra.largeandhighquality.com";
            identityAgent = secretive;
          }
          {
            hostname = "ssh.pijul.com";
            port = 22;
            identityAgent = _1password;
          }
          {
            hostname = "zhloe.infra.largeandhighquality.com";
            identityAgent = secretive;
          }
        ]
      );
  };

  programs.vscode = {
    enable = false;
    profiles.default.extensions = [
      pkgs.vscode-extensions.editorconfig.editorconfig
      mark-hansen.hledger-vscode
    ];
    profiles.default.userSettings = {
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
      "dotnet.dotnetPath" = pkgs.dotnet-sdk_8;
      "FSharp.dotnetRoot" = pkgs.dotnet-sdk_8;
      "omnisharp.dotnetPath" = pkgs.dotnet-sdk_8;
      "omnisharp.sdkPath" = pkgs.dotnet-sdk_8;
      "dotnetAcquisitionExtension.existingDotnetPath" = [
        {
          extensionId = "ms-dotnettools.csharp";
          path = "${lib.getBin pkgs.dotnet-sdk_8}/bin/dotnet";
        }
      ];
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
