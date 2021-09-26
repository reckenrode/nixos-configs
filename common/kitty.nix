{ pkgs, ... }:

{
  environment.variables = {
    TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  };
}
