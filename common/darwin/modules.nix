flake:

[
  flake.inputs.home-manager.darwinModules.home-manager
] ++ flake.lib.loadModules ./modules
