{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "randy@largeandhighquality.com";
    userName = "Randy Eckenrode";
    signing = {
      key = "01D754863A6D64EAAC770D26FBF19A982CCE0048";
      signByDefault = true;
    };
    lfs.enable = true;
    extraConfig = {
      init = { defaultBranch = "main"; };
      credential.helper = "${pkgs.git}/bin/git-credential-osxkeychain";
    };
  };
}
