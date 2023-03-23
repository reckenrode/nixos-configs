# SPDX-License-Identifier: MIT

{ pkgs, lib, config, ... }:

{
  home.packages = lib.attrValues {
    inherit (pkgs) neovim ripgrep;
  };

  home.sessionVariables = {
    EDITOR = "${lib.getBin pkgs.neovim}/bin/nvim";
  };

  home.stateVersion = "22.11";

  programs.fish.enable = true;

  xdg.enable = true;
  xdg.userDirs.enable = true;
}
