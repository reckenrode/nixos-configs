# SPDX-License-Identifier: MIT

{ pkgs, lib, config, ... }:

{
  disabledModules = [ "misc/xdg-user-dirs.nix" ];

  imports = [  ./xdg-user-dirs.nix ];

  config = lib.mkIf (pkgs.stdenv.isDarwin && config.xdg.userDirs.enable) {
    xdg.userDirs.videos = "${config.home.homeDirectory}/Movies";
    xdg.userDirs.templates = null;
  };
}
