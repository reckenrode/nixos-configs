{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    ripgrep
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -x EDITOR "${pkgs.neovim}/bin/nvim";
    '';
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
  };

  home.stateVersion = "21.05";
}
