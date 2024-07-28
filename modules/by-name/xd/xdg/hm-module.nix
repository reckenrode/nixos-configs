# SPDX-License-Identifier: MIT

{
  lib,
  config,
  pkgs,
  ...
}:

let
  mkXdgHomeBin = lib.mkOrder 0 ''install -m 700 -d "$HOME/.local/bin"'';
in
{
  imports = [
    ./bash.nix
    ./cargo.nix
    ./dotnet.nix
    ./gnupg.nix
    ./less.nix
    ./python.nix
  ];

  config = lib.mkMerge [
    (lib.mkIf (pkgs.stdenv.isDarwin && config.xdg.enable) {
      # Move Cache home to ~/Library/Caches, so it plays nicely with backups
      xdg.cacheHome = "${config.home.homeDirectory}/Library/Caches";

      launchd.agents.xdg_cache_home = {
        enable = true;
        config = {
          Program = "/bin/launchctl";
          ProgramArguments = [
            "/bin/launchctl"
            "setenv"
            "XDG_CACHE_HOME"
            config.xdg.cacheHome
          ];
          RunAtLoad = true;
          StandardErrorPath = "/dev/null";
          StandardOutPath = "/dev/null";
        };
      };
    })
    (lib.mkIf config.xdg.enable {
      programs.bash.initExtra = mkXdgHomeBin;
      programs.fish.loginShellInit = mkXdgHomeBin;
      programs.zsh.initExtraFirst = mkXdgHomeBin;
    })
  ];
}
