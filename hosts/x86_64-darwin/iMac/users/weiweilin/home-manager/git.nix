{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "stormer.boxes-06@icloud.com";
    userName = "Weiwei Lin";
    extraConfig = {
      init = { defaultBranch = "main"; };
      credential.helper = "${pkgs.git}/bin/git-credential-osxkeychain";
    };
  };
}
