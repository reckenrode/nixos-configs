let
  inherit (import ./.) readDirNames;

  mkHost = { self, hostsPath, system }: name:
    let
      inherit (builtins) concatMap elemAt filter map mapAttrs pathExists split;
      inherit (self.inputs) darwin home-manager;

      # Define `optionalAttrs` and `id` manually because trying to access
      # `self.input.nixpkgs` causes an infinite recursion.
      optionalAttrs = pred: attrs: if pred then attrs else { };

      platformTuple = split "-" system;
      platform = elemAt platformTuple 2;
      arch = elemAt platformTuple 0;

      fullHostPath = hostsPath + /${system}/${name};
      usersPath = fullHostPath + /users;

      users = if pathExists usersPath then readDirNames usersPath else [ ];

      paths =
        map (user: ../common/users/${user}) users ++ map (user: usersPath + /${user}) users ++ [
          ../common/${platform}
          ../common/${platform}/${arch}
          fullHostPath
        ];

      configPaths = map (path: path + /configuration.nix) paths;
      configs = filter pathExists configPaths;

      modulesPaths = map (path: path + /modules.nix) paths;
      modulesConfigs = concatMap (src: import src self) (filter pathExists modulesPaths);

      aarch64ExtraPkgs = optionalAttrs (system == "aarch64-darwin") {
        x86_64 = {
          flakePkgs = self.packages."x86_64-${platform}";
          pkgs = self.pkgs."x86_64-${platform}".nixpkgs;
          unstablePkgs = self.pkgs."x86_64-${platform}".nixpkgs-unstable;
        };
      };
    in
    {
      inherit name;
      value = {
        inherit system;
        modules = configs ++ modulesConfigs;
        specialArgs = aarch64ExtraPkgs // {
          flake = self;
          hostPath = fullHostPath;
          flakePkgs = self.outputs.packages."${system}";
          unstablePkgs = self.outputs.pkgs."${system}".nixpkgs-unstable;
        };
      } // optionalAttrs (platform == "darwin") {
        output = "darwinConfigurations";
        builder = darwin.lib.darwinSystem;
      };
    };

  mkSystem = args@{ hostsPath, ... }: system:
    let
      hosts = readDirNames (hostsPath + /${system});
    in
    builtins.map (mkHost (args // { inherit system; })) hosts;

  mkHosts = args@{ self, hostsPath }:
    let
      inherit (builtins) concatMap listToAttrs;

      systems = readDirNames hostsPath;
    in
    listToAttrs (concatMap (mkSystem args) systems);
in
mkHosts
