{ pkgs, lib, flake, ... }:

# nix.nixPath based on the logic from `flake-utils-plus`
# https://github.com/gytis-ivaskevicius/flake-utils-plus/blob/v1.3.0/lib/options.nix
let
  inherit (builtins) map;
  inherit (lib) mkForce filterAttrs mapAttrsToList;
  inherit (lib.trivial) pipe;

  hasOutputs = _: flake: flake ? outputs;
  hasPackages = _: flake: flake.outputs ? legacyPackages || flake.outputs ? packages;

  flakesWithPkgs = pipe flake.inputs (map filterAttrs [ hasOutputs hasPackages ]);
  nixPath = mapAttrsToList (name: _: "${name}=/etc/nix/inputs/${name}") flakesWithPkgs;
in
{
  imports = [
    ./nix-optimizations-darwin.nix
  ];

  nix.nixPath = mkForce nixPath;

  programs.bash.enable = false;

  services.nix-daemon.enable = true;

  environment.variables = {
    TERMINFO_DIRS = "$HOME/.nix-profile/share/terminfo:/etc/profiles/per-user/$USER/share/terminfo:/nix/var/nix/profiles/default/share/terminfo:/run/current-system/sw/share/terminfo:${pkgs.kitty.terminfo}/share/terminfo";
  };

  users.nix.configureBuildUsers = true;
}
