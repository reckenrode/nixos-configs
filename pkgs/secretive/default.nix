{ lib, fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  pname = "secretive";
  version = "2.2.0";

  src = fetchurl {
    name = "Secretive-${version}.zip";
    url = "https://github.com/maxgoedjen/secretive/releases/download/v${version}/Secretive.zip";
    hash = "sha256-gjB8bevzbgYZ1GtAVMK+IBp9eP+Y79s8RhK/sdg7AI8=";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/Applications
    cp -R ../*.app $out/Applications
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
