{ lib, pkgs, ... }:

{
  programs.fish.enable = true;

  programs.fish.shellAliases = lib.optionalAttrs pkgs.stdenv.isDarwin {
    trash = "trash -F";
  };

  programs.fish.loginShellInit = lib.optionalString pkgs.stdenv.isDarwin ''
    set fish_user_paths $HOME/.local/bin $HOME/.nix-profile/bin /etc/profiles/per-user/reckenrode/bin /run/current-system/sw/bin /nix/var/nix/profiles/default/bin
  '';
}
