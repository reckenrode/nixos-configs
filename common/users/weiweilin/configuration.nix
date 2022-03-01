{ lib, pkgs, ... }:

{
  users.users.weiweilin = {
    description = "Weiwei Lin";
    shell = pkgs.zsh;
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    home = "/Users/weiweilin";
  };
}
