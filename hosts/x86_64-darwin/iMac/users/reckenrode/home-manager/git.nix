{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "randy@largeandhighquality.com";
    userName = "Randy Eckenrode";
  };
}
