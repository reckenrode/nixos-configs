These are my NixOS and nix-darwin configs. Everything is flake-based, so I can have my servers
update automatically.  Secrets are kept in [sops-nix][2].

I use [flake-utils-plus][1] to build the flake, but the repository itself is set up to allow my
configs to be convention-based (see below for the convention).  This allows me to create a new host
just by putting a `configuration.nix` in the directory for that host and platform.

## Convention Specification

### System Configuration

The core flake is written to allow for a lot of flexibility.  It is possible to define NixOS and
nix-darwin configuration on the following bases.  All directories should contain a
`configuration.nix`.  Note that a directory for a user must exist in the host’s `users` directory
for its configuration to be picked up from the common configuration.

* **All platforms:** `common/configuration.nix`
* **Platform (architecture-independent)**: `common/<platform>`
* **Platform (architecture-specific)**: `common/<platform>/<architecture>`
* **Host**: `hosts/<architecture-platform>/<host name>`
* **User (all platforms)**: `common/users/<user name>`
* **User (host-specific)**: `hosts/<architecture-platform>/<host name>`

### Modules

Modules for a host or user may be specified by putting a `modules.nix` file in one of the above
directories.  This file should contain a function that takes the flake’s inputs and returns a list
of modules.

### Home Manager

[Home Manager][3] is used to manage dot-files for the hosts users (as specified above). Home Manager
configuration is likewise configured by convention.  All `home-manager` directories should contain a
`default.nix`.

* **Platform (architecture-independent)**: `common/<platform>/home-manager`
* **Platform (architecture-specific)**: `common/<platform>/<architecture>/home-manager`
* **Host**: `hosts/<architecture-platform>/<host name>/home-manager`
* **User (all platforms)**: `common/users/<user name>/home-manager`
* **User (host-specific)**: `hosts/<architecture-platform>/<host name>/home-manager`

### Example

For example, `zhloe` contains the following configuration: a host definition, Linux-configuration,
and home-manager configuration.  Its configuration is found in the following directories:

* `common/configuration.nix`
* `common/linux/configuration.nix`
* `common/linux/modules.nix`
* `hosts/linux/x86_64-linux/zhloe/configuration.nix`
* `hosts/linux/x86_64-linux/zhloe/modules.nix`
* `hosts/linux/x86_64-linux/zhloe/users/reckenrode`
* `common/users/reckenrode/configuration.nix`
* `common/users/reckenrode/home-manager`

## Extra Packages

My configs follow the `nixos-22.05` channel on both Linux and Darwin.  A GitHub action updates
`flake.lock` nightly.  Two additional package repositories are made available in this flake (for
both system and Home Manager configuration).

* **flakePkgs**: This is the contents of the flake’s `packages` attribute.
* **unstablePkgs**: This tracks `nixos-unstable`.

[1]: https://github.com/gytis-ivaskevicius/flake-utils-plus/
[2]: https://github.com/Mic92/sops-nix
[3]: https://github.com/nix-community/home-manager
