{ config, pkgs, ... }:

{
  system.activationScripts.diffClosures.text = ''
    ${config.nix.package}/bin/nix store --experimental-features 'nix-command' diff-closures \
      /run/current-system "$systemConfig"
  '';
}
