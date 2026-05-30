# SPDX-License-Identifier: MIT

{
  lib,
  pkgs,
  inputs,
  ...
}:

{
  home = {
    username = "reckenrode";
    homeDirectory = "/Users/reckenrode";
    stateVersion = "26.05";
  };

  home.packages =
    lib.attrValues {
      inherit (pkgs) btop ripgrep waifu2x-converter-cpp;
      inherit (pkgs.darwin) trash;
    };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.fish.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "randy@largeandhighquality.com";
        name = "Randy Eckenrode";
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
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.jujutsu;
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
    settings =
      let
        secretive = "~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
        _1password = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
      in
      {
        "github.com" = {
          IdentityAgent = secretive;
        };
        "largeandhighquality.com" = {
          Port = 562;
          IdentityAgent = secretive;
        };
        "meteion.infra.largeandhighquality.com" = {
          Port = 562;
          IdentityAgent = secretive;
        };
        "zhloe.infra.largeandhighquality.com" = {
          Port = 562;
          IdentityAgent = secretive;
        };
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
