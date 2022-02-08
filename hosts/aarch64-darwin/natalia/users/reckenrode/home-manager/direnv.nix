{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    stdlib = ''
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
              echo -n "$XDG_CACHE_HOME"/direnv/layouts/
              echo -n "$PWD" | shasum | cut -d ' ' -f 1
          )}"
      }
      # FIXME: Remove once nix-direnv 1.5.1 is available.
      # See: https://github.com/nix-community/nix-direnv/issues/120#issuecomment-967747092
      sed() { ${pkgs.gnused}/bin/sed "$@"; }
    '';
  };

  programs.direnv.nix-direnv = {
    enable = true;
    enableFlakes = true;
  };
}
