let
  inherit (import ./.) readDirNames;
in
modulesPath:
map (module: import "${modulesPath}/${module}") (readDirNames modulesPath)
