{ lib, fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  pname = "secretive";
  version = "2.1.1";

  src = fetchurl {
    url = "https://github.com/maxgoedjen/secretive/releases/download/v${version}/Secretive.zip";
    hash = "sha256-JKeUZFBggML7fyBnFnj3J/Xi6/Q2g5yLkK2VPTBf2Zk=";
  };

  buildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';

  meta = {
    description = ''
      Secretive is an app for storing and managing SSH keys in the Secure Enclave. It is inspired by
      the sekey project, but rewritten in Swift with no external dependencies and with a handy
      native management app.
    '';
    homepage = "https://github.com/maxgoedjen/secretive";
    changelog = "https://github.com/maxgoedjen/secretive/releases";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
  };
}
