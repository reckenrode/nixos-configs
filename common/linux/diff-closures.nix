{ pkgs, ... }:

{
  system.activationScripts.diffClosures.text = ''
    ${pkgs.nix_2_4}/bin/nix store --experimental-features 'nix-command' diff-closures \
      /run/current-system "$systemConfig"
  '';
}
