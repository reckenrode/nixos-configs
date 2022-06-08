{ config
, lib
, pkgs
, ...
}:

{
  imports = [
    ./shares.nix
    ./time-machine.nix
  ];

  # services.elasticsearch.enable = true;

  networking.nftables.ruleset = builtins.readFile ./samba.nft;

  services.samba = {
    enable = true;
    package = pkgs.samba.override { enableMDNS = true; };
    securityType = "user";
    extraConfig = ''
      # Performance optimizations
      socket options = TCP_NODELAY IPTOS_LOWDELAY
      use sendfile = yes
      aio read size = 1
      aio write size = 1

      # Mac-friendly client settings
      #vfs objects = zfsacl catia fruit streams_xattr
      vfs objects = catia fruit streams_xattr
      fruit:aapl = yes
      fruit:resource = xattr
      fruit:metadata = stream
      fruit:encoding = native
      fruit:wipe_intentionally_left_blank_rfork = yes

      # Enable support for Spotlight queries
      #spotlight backend = elasticsearch
      #elasticsearch:address = localhost
      #elasticsearch:port = ${toString config.services.elasticsearch.port}
    '';
  };

  sops.secrets.smbpasswd = {
    mode = "400";
  };

  system.activationScripts = lib.mkIf config.services.samba.enable {
    sambaUserSetup = {
      text = ''
        ${pkgs.samba}/bin/pdbedit \
          -i smbpasswd:/run/secrets/smbpasswd \
          -e tdbsam:/var/lib/samba/private/passdb.tdb
      '';
      deps = [ "setupSecrets" ];
    };
  };
}
