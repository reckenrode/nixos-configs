{ ... }:

{
  programs.fish.shellAliases = {
    trash = "trash -F";
  };

  programs.fish.loginShellInit = let
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
}
