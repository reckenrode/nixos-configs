let
  inherit (import ./.) readDirNames;

  mkHost = { self, hostsPath, channels, overlays, system }: name:
    let
      inherit (builtins) concatMap elemAt filter map mapAttrs pathExists split;
      inherit (self.inputs) darwin home-manager;

      # Define `optionalAttrs` and `id` manually because trying to access
      # `self.input.nixpkgs` causes an infinite recursion.
      optionalAttrs = pred: attrs: if pred then attrs else {};
      
      platformTuple = split "-" system;
      platform = elemAt platformTuple 2;
      arch = elemAt platformTuple 0;

      fullHostPath = hostsPath + /${system}/${name};
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
      modulesConfigs = concatMap (src: import src self.inputs) (filter pathExists modulesPaths);

      aarch64ExtraPkgs = optionalAttrs (arch == "aarch64") {
        x86_64 =
          let
            flakePackages = self.packages."x86_64-${platform}";
          in
          rec {
            flakePkgs = mapAttrs (_: pkg: pkgs.callPackage pkg.override {}) flakePackages;
            pkgs = import self.inputs.nixpkgs {
              config = channels.nixpkgs.config or {} // {
                allowUnsupportedSystem = true;
              };
              localSystem = system;
              overlays = [ overlays ];
            };
            unstablePkgs = self.inputs.nixpkgs-unstable {
              config = channels.nixpkgs-unstable.config or {} // {
                allowUnsupportedSystem = true;
              };
              localSystem = system;
            };
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
          flakePkgs = self.outputs.packages.${system};
          unstablePkgs = self.outputs.pkgs.${system}.nixpkgs-unstable;
          extraSpecialArgs = aarch64ExtraPkgs // {
            flake = self;
            flakePkgs = self.outputs.packages.${system};
            unstablePkgs = self.outputs.pkgs.${system}.nixpkgs-unstable;
          };
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

  mkHosts = args@{ self, hostsPath, channels, overlays }:
    let
      inherit (builtins) concatMap listToAttrs;

      systems = readDirNames hostsPath;
    in
    listToAttrs (concatMap (mkSystem args) systems);
in
mkHosts
