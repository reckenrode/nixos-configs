{ pkgs, ... }:

{
  programs.fish.shellAliases = {
    trash = "trash -F";
  };

  programs.fish.loginShellInit = let
    fishUserPaths = builtins.foldl' (a: b: "${a} ${b}") "" [
      "$HOME/.local/bin"
      "$HOME/.nix-profile/bin"
      "/etc/profiles/per-user/reckenrode/bin"
      "/run/current-system/sw/bin"
      "/nix/var/nix/profiles/default/bin"
    ];
    secretivePath = "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
  in ''
    set fish_user_paths ${fishUserPaths}
    set -x SSH_AUTH_SOCK ${secretivePath}
  '';

}
