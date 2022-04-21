{ pkgs, ... }:

{
  programs.fish = {
    functions =
      let
        inherit (pkgs) findutils coreutils nvd;
      in
      {
        darwin-rebuild = ''
          pushd (pwd)
          if string match -q switch -- $argv
            set scratch_dir (${coreutils}/bin/mktemp -d)
            function clean_up_scratch --on-event EXIT -e INT -e QUIT -e TERM
                ${coreutils}/bin/rm -rf $scratch
            end
            popd
            pushd $scratch_dir
          end
          command darwin-rebuild $argv
          popd
        '';
      };

    loginShellInit =
      let
        fishUserPaths = builtins.foldl' (a: b: "${a} ${b}") "" [
          "/nix/var/nix/profiles/per-user/$USER/profile/bin"
          "/etc/profiles/per-user/$USER/bin"
          "/nix/var/nix/profiles/default/bin"
          "/run/current-system/sw/bin"
        ];
        fishHomePaths = builtins.foldl' (a: b: "${a} ${b}") "" [
          "$HOME/.local/bin"
        ];
      in
      ''
        set -g fish_user_paths ${fishUserPaths}
        fish_add_path -g --path --append --move ${fishHomePaths}
        # Remove home-local path from $PATH
        set -g -e PATH[$(contains -i "$HOME/.nix-profile/bin" $PATH)]
      '';
  };
}
