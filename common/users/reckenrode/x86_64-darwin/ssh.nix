{ lib, pkgs, ... }:

let
  mkConfig = { host ? hostname, hostname, port ? 562, user ? "reckenrode", identityFile ? null}: {
    name = host;
    value = {
      inherit hostname port user;
    } // lib.optionalAttrs (identityFile != null) {
      identityFile = [ "${identityFile}" ];
      identitiesOnly = true;
    };
  };
in {
  home.packages = [ pkgs.openssh ];

  programs.ssh = {
    enable = true;
    matchBlocks = builtins.listToAttrs (map mkConfig [
      { hostname = "github.com"; }
      { hostname = "imac.local"; port = 22; user = "kenada"; }
      { hostname = "vtt.largeandhighquality.com"; }
      { hostname = "www.largeandhighquality.com"; }
      { hostname = "zhloe.infra.largeandhighquality.com"; }
    ]);
  };
}
