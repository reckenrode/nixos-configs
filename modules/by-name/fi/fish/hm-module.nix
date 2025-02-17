# SPDX-License-Identifier: MIT

{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) concatMapStringsSep foldl';
in
{
  imports = [ ./gnupg.nix ];

  programs.fish.loginShellInit =
    let
      fishUserPaths = lib.optional pkgs.stdenv.hostPlatform.isLinux "/run/wrappers/bin" ++ [
        "/nix/var/nix/profiles/per-user/${config.home.username}/profile/bin"
        "/etc/profiles/per-user/${config.home.username}/bin"
        "/nix/var/nix/profiles/default/bin"
        "/run/current-system/sw/bin"
      ];

      fishHomePath = config.home.homeDirectory + "/.local/bin";

      toFishList = concatMapStringsSep " " toQuotedPath;
      toQuotedPath = lib.flip lib.pipe [
        (lib.replaceStrings [ "'" ] [ "\\'" ])
        (path: "'${path}'")
      ];
    in
    ''
      set -g fish_user_paths ${toFishList fishUserPaths}
      fish_add_path -g --path --append --move ${toQuotedPath fishHomePath}
      # Remove home-local path from $PATH
      contains -i '${config.home.homeDirectory}/.nix-profile/bin' $PATH > /dev/null \
      && set -g -e PATH[$(contains -i '${config.home.homeDirectory}/.nix-profile/bin' $PATH)]
    '';

  programs.fish.functions = {
    fish_prompt = ''
      set -l last_pipestatus $pipestatus
      set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
      set -l normal (set_color normal)
      set -q fish_color_status
      or set -g fish_color_status --background=red white

      # Color the prompt differently when we're root
      set -l color_cwd $fish_color_cwd
      set -l suffix '>'
      if functions -q fish_is_root_user; and fish_is_root_user
          if set -q fish_color_cwd_root
              set color_cwd $fish_color_cwd_root
          end
          set suffix '#'
      end

      # Write pipestatus
      # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
      set -l bold_flag --bold
      set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
      if test $__fish_prompt_status_generation = $status_generation
          set bold_flag
      end
      set __fish_prompt_status_generation $status_generation
      set -l status_color (set_color $fish_color_status)
      set -l statusb_color (set_color $bold_flag $fish_color_status)
      set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

      # Write whether the shell is in a nix shell
      set -l shlvl (
        if test "$SHLVL" -gt 1
          echo -n "<subshell #$(math "$SHLVL"-1)> "
        end
      )

      echo -n -s (prompt_login)' ' $shlvl (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal " "$prompt_status $suffix " "
    '';

    # Based on https://gist.github.com/hroi/d0dc0e95221af858ee129fd66251897e
    fish_jj_prompt = ''
      # Is jj installed?
      if not command -sq jj
          return 1
      end

      # Are we in a jj repo?
      if not jj root --quiet &>/dev/null
          return 1
      end

      # Generate prompt
      jj log --ignore-working-copy --no-graph --color always -r @ -T '
        surround(
          " (", ")",
          separate(
            " ",
            bookmarks.join(", "),
            change_id.short(8),
            surround(
              "(", ")",
              separate(
                ", ",
                if(conflict, "conflict"),
                if(empty, "empty"),
                if(divergent, "divergent"),
                if(hidden, "hidden"),
                if(!description, "no description"),
              )
            )
          )
        )
      '
    '';

    fish_title = ''
      set host (hostname -s)
      set user $USER
      set path (prompt_pwd)
      set job $_
      echo "$user@$host:$path  $job"
    '';

    fish_vcs_prompt = ''
      fish_jj_prompt $argv
      or fish_git_prompt $argv
      or fish_hg_prompt $argv
      or fish_fossil_prompt $argv
    '';
  };
}
