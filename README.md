These are my NixOS and nix-darwin configs. Everything is flake-based, so I can have my servers
update automatically.  Secrets are kept in [sops-nix][sops-nix].

A prior version of this flake relied on convention.  For those interested, it is available on the
`attic` branch.  I have removed the GitHub Action and lockfile on that branch because it is not
actively used anymore.

The current version of this flake favors explicit configuration and uses modules to share common
configuration settings.  The modules directory organization is inspired by [RFC-0140][rfc-0140].

## Extra Packages

I no longer maintain packages in this repository.  They have been moved to
[reckenrode/nix-packages][nix-packages].  See that repository for more details on packages and
available modules.

[home-manager]: https://github.com/nix-community/home-manager
[nix-packages]: https://github.com/reckenrode/nix-packages
[rfc-0140]: https://github.com/NixOS/rfcs/pull/140
[sops-nix]: https://github.com/Mic92/sops-nix
