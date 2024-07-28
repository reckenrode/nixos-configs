# SPDX-License-Identifier: MIT

# Based on https://github.com/gytis-ivaskevicius/flake-utils-plus/blob/baf73049d14736b3bd3d3d8ccb0daac209fbf291/lib/options.nix

{
  lib,
  config,
  inputs,
  ...
}:

let
  inherit (lib)
    filterAttrs
    mapAttrs
    mapAttrs'
    mapAttrsToList
    nameValuePair
    types
    ;
  inherit (lib.trivial) pipe;

  hasDarwinConfig = config.environment ? darwinConfig;
  inherit (config.environment) darwinConfig;

  linkedInputs =
    mapAttrs' (name: value: nameValuePair "nix/inputs/${name}" { source = value; }) inputs
    // lib.optionalAttrs hasDarwinConfig { "nix/inputs/darwin-config".source = darwinConfig; };

  flakeRegistry = mapAttrs (_: value: { flake = value; }) inputs;

  cfg = config.nix;
in
{
  options.nix = {
    generateRegistryFromInputs = lib.mkEnableOption "Generate `nix.registry` from inputs.";

    generateNixPathFromInputs = lib.mkEnableOption "Generate `nix.nixPath` from inputs.";

    linkInputs = lib.mkOption {
      type = types.bool;
      description = "Link inputs to `/etc/nix/inputs`.";
      default = cfg.generateNixPathFromInputs;
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.generateNixPathFromInputs -> cfg.linkInputs;
        message = "Enabling `nix.generateNixPathFromInput` requires `nix.linkInputs` be enabled.";
      }
    ];

    environment.etc = lib.mkIf cfg.linkInputs linkedInputs;

    nix.nixPath = lib.mkIf cfg.generateNixPathFromInputs (lib.mkForce [ "/etc/nix/inputs" ]);
    nix.registry = lib.mkIf cfg.generateRegistryFromInputs flakeRegistry;
  };
}
