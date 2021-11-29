{ pkgs, ... }:

{
  programs.fish = {
    functions =
      let
        inherit (pkgs) findutils coreutils nvd;
      in
      {
        darwin-rebuild = ''
          function get_gen
            ${findutils}/bin/find -L /nix/var/nix/profiles \
              -maxdepth 1 -samefile (${coreutils}/bin/readlink /run/current-system) \
              | ${coreutils}/bin/sort \
              | ${coreutils}/bin/tail -n1
          end

          if string match -q switch -- $argv
            set old_gen (get_gen)

            set scratch_dir (${coreutils}/bin/mktemp -d)
            function clean_up_scratch --on-event EXIT -e INT -e QUIT -e TERM
                ${coreutils}/bin/rm -rf $scratch
            end

            pushd $scratch_dir
            command darwin-rebuild $argv
            popd

            set new_gen (get_gen)

            ${nvd}/bin/nvd diff $old_gen $new_gen
          else
            command darwin-rebuild $argv
          end
        '';
    };
    loginShellInit = let
      fishUserPaths = builtins.foldl' (a: b: "${a} ${b}") "" [
        "$HOME/.nix-profile/bin"
        "/etc/profiles/per-user/$USER/bin"
        "/nix/var/nix/profiles/default/bin"
        "/run/current-system/sw/bin"
      ];
    in ''
      set fish_user_paths ${fishUserPaths}
      set --append PATH "$HOME/.local/bin"
    '';
  };
}
