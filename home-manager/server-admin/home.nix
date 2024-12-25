# SPDX-License-Identifier: MIT

{
  lib,
  pkgs,
  ...
}:

{
  home.packages = lib.attrValues { inherit (pkgs) neovim ripgrep; };

  home.sessionVariables = {
    EDITOR = "${lib.getBin pkgs.neovim}/bin/nvim";
  };

  home.stateVersion = "24.11";

  programs.fish.enable = true;

  xdg.enable = true;
  xdg.userDirs.enable = true;
}
