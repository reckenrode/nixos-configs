{ pkgs, ... }:
{
  security.acme = {
    acceptTerms = true;
    certs = {
      "infra.largeandhighquality.com" = {
        credentialsFile = "/var/lib/secrets/acme/linode";
        dnsProvider = "linodev4";
        domain = "*.infra.largeandhighquality.com";
        email = "randy@largeandhighquality.com";
        postRun = builtins.readFile (pkgs.substituteAll {
          src = ./update-printer;
          inherit (pkgs) coreutils curl openssl;
        });
      };
    };
  };
}
