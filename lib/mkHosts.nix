let
  inherit (import ./.) readDirNames;

  mkHost = flake: hostPath: system: name:
    let
      inherit (builtins) concatMap elemAt filter map pathExists split;
      inherit (flake.inputs) darwin home-manager;

      # Define `optionalAttrs` manually because trying to access
      # `flake.input.nixpkgs` causes an infinite recursion.
      optionalAttrs = pred: attrs: if pred then attrs else {};
      
      platformTuple = split "-" system;
      platform = elemAt platformTuple 2;
      arch = elemAt platformTuple 0;

      fullHostPath = hostPath + /${system}/${name};
      usersPath = fullHostPath + /users;

      users = if pathExists usersPath then readDirNames usersPath else [];

      paths =
        map (user: ../common/users/${user}) users ++ map (user: usersPath + /${user}) users ++ [
          ../common/${platform}
          ../common/${platform}/${arch}
          fullHostPath
        ];

      configPaths = map (path: path + /configuration.nix) paths;
      configs = filter pathExists configPaths;

      modulesPaths = map (path: path + /modules.nix) paths;
      modulesConfigs = concatMap (src: import src flake.inputs) (filter pathExists modulesPaths);
    in
    {
      inherit name;
      value = {
        inherit system;
        modules = configs ++ modulesConfigs;
        specialArgs = {
          inherit flake;
          hostPath = fullHostPath;
          flakePkgs = flake.outputs.packages.${system};
          unstablePkgs = flake.outputs.pkgs.${system}.nixpkgs-unstable;
          extraSpecialArgs = {
            inherit flake;
            flakePkgs = flake.outputs.packages.${system};
            unstablePkgs = flake.outputs.pkgs.${system}.nixpkgs-unstable;
          };
        };
      } // optionalAttrs (platform == "darwin") {
        output = "darwinConfigurations";
        builder = darwin.lib.darwinSystem;
      };
    };

  mkSystem = flake: hostPath: system: 
    let
      inherit (builtins) mapAttrs;

      hosts = readDirNames (hostPath + /${system});
    in
    builtins.map (mkHost flake hostPath system) hosts;

  mkHosts = flake: hostPath: 
    let
      inherit (builtins) concatMap listToAttrs;

      systems = readDirNames hostPath;
    in
    listToAttrs (concatMap (mkSystem flake hostPath) systems);
in
mkHosts
