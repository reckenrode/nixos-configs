These are my NixOS and nix-darwin configs. Everything is flake-based, so I can have my servers
update automatically. Secrets are kept in [sops-nix][1]. There are a handful of overlays I should
try to upstream someday. If you’re interested in using any of this, you’ll want to clone the
repository and change the system-specific stuff.

## Repository Structure

The repository is structured such to help `flake.nix` effect per-host and architecture- 
configuration without having to write that explicitly in the flake. Architecture specifications
follow the Nix convention (x86_64-linux, aarch64-darwin, etc).

- **common:** configuration shared across hosts
  - **darwin.nix:** configuration for Darwin-based hosts
  - **linux.nix:** configuration for Linux-based hosts
  - **home-manager/&lt;architecture&gt;**: architecture-specific home-manager configuration
  - **users/&lt;username&gt;:** non-system (i.e., interactive) user definitions
    - **default.nix:** user definitions
    - **home-manager.nix:** user-specific home-manager configuration
- **hosts/&lt;architecture&gt;/&lt;hostname&gt;:** host-specific configuration
  - **users/&lt;username&gt;:** system-specific home-manager configuration for the user
- **pkgs:** custom package derivations

[1]: https://github.com/Mic92/sops-nix
