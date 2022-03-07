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
          "/etc/profiles/per-user/$USER/bin"
          "/nix/var/nix/profiles/default/bin"
          "/run/current-system/sw/bin"
        ];
        fishHomePaths = builtins.foldl' (a: b: "${a} ${b}") "" [
          "$HOME/.nix-profile/bin"
          "$HOME/.local/bin"
        ];
      in
      ''
        fish_add_path --path --prepend --move ${fishUserPaths}
        fish_add_path --path --append --move ${fishHomePaths}
      '';
  };
}
