{ pkgs, unstablePkgs, ... }:

{
  programs.fish.functions = {
    fish_title = ''
      set host (hostname -s)
      set user $USER
      set path (prompt_pwd)
      set job $_
      echo "$user@$host:$path  $job"
    '';
  };
  home.packages =
    let
      iterm2 = pkgs.callPackage unstablePkgs.iterm2.override { };
    in
    [
      iterm2
    ];
}
