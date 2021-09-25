let
  inherit (import ./.) readDirNames;

  mkHost = flake: hostPath: system: name:
    let
      inherit (builtins) filter map pathExists;
      inherit (flake.inputs) darwin home-manager;

      # Define `hasSuffix` and `optionalAttrs` manually because trying to access
      # `flake.input.nixpkgs` causes an infinite recursion.
      hasSuffix = substr: target:
        let
          inherit (builtins) stringLength substring;
          substrLength = stringLength substr;
          offset = (stringLength target) - substrLength;
        in
        offset >= 0 && substring offset substrLength target == substr;
      
      optionalAttrs = pred: attrs: if pred then attrs else {};
      
      isDarwin = hasSuffix "darwin" system;

      hasDefaultNix = path: pathExists (path + "/default.nix");

      fullHostPath = hostPath + /${system}/${name};

      usersPath = fullHostPath + "/users";
      users = if pathExists usersPath
      	then readDirNames usersPath
        else [];

      commonUserConfigs = filter hasDefaultNix (map (user: ../common/users + "/${user}") users);
      userConfigs = filter hasDefaultNix (map (user: usersPath + /${user}) users);

      homeManagerModule = if isDarwin
        then home-manager.darwinModule
        else home-manager.nixosModule;
      platformConfiguration = if isDarwin
        then ../common/darwin
        else ../common/linux;
      hostConfiguration = hostPath + /${system}/${name}/configuration.nix;
    in
    {
      inherit name;
      value = {
        inherit system;
        modules = [
          homeManagerModule
          platformConfiguration
          hostConfiguration
          ../common/home-manager.nix
        ] ++ commonUserConfigs
          ++ userConfigs;
        specialArgs = {
          host = hostConfiguration;
          extraSpecialArgs = {
            flakePkgs = flake.outputs.packages.${system};
            unstablePkgs = flake.outputs.pkgs.${system}.nixpkgs-unstable;
          };
        };
      } // optionalAttrs isDarwin {
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
