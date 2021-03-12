{ config, pkgs, ... }:

{
  targets.darwin.defaults."com.fournova.Tower3" = {
    GTUserDefaultsDefaultCloningDirectory = "${config.home.homeDirectory}/Sources";
    GTUserDefaultsGitBinary = "${pkgs.git}/bin/git";
  };
}
