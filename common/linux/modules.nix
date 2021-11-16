flake:

[
  flake.inputs.home-manager.nixosModules.home-manager
] ++ flake.lib.loadModules ./modules
