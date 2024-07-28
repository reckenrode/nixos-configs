# SPDX-License-Identifier: MIT

{
  lib,
  config,
  ...
}:

{
  config = lib.mkIf config.programs.direnv.enable {
    programs.direnv = {
      stdlib = ''
        : ''${XDG_CACHE_HOME:=$HOME/.cache}
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
                echo -n "$XDG_CACHE_HOME"/direnv/layouts/
                echo -n "$PWD" | shasum | cut -d ' ' -f 1
            )}"
        }
      '';
    };
  };
}
