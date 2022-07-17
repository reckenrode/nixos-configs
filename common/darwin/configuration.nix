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
    ./copy-applications.nix
    ./diff-closures.nix
    ./iterm2.nix
    ./nix-optimizations-darwin.nix
  ];

  nix = {
    useSandbox = "relaxed";
    nixPath = mkForce nixPath;
  };

  # Too many packages try to spawn a server during their tests and connect to it,
  # so relax the sandbox to prevent build failures.
  security.sandbox.profiles.allowLocalNetworking = true;

  programs.bash.enable = false;

  services.nix-daemon.enable = true;

  system.defaults.ActivityMonitor.ShowCategory = null;

  users.nix.configureBuildUsers = true;
}
