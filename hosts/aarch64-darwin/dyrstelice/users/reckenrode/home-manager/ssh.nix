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
      { hostname = "github.com"; port = 22; }
      { hostname = "imac.local"; port = 22; }
      { hostname = "largeandhighquality.com"; }
      { hostname = "zhloe.infra.largeandhighquality.com"; }
    ]);
  };
}
