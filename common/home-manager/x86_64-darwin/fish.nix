{ pkgs, ... }:

{
  programs.fish = {
    functions = {
      darwin-rebuild = with pkgs; ''
        function get_gen
          ${findutils}/bin/find -L /nix/var/nix/profiles \
            -maxdepth 1 -samefile (readlink /run/current-system) | sort | tail -n1
        end
        
        if string match -q switch -- $argv
          set old_gen (get_gen)
          
          set scratch_dir (${coreutils}/bin/mktemp -d)
          pushd $scratch_dir
          command darwin-rebuild $argv
          popd
          rm -rf $scratch_dir
          
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
