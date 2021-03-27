{ lib, fetchurl, stdenv, unzip }:

stdenv.mkDerivation rec {
  pname = "secretive";
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/maxgoedjen/secretive/releases/download/v${version}/Secretive.zip";
    sha256 = "WSHYxFKsnk9ddJ2sFiy1sExEvBNDYxTjZ1V5khMR3JU=";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';

  meta = with lib; {
    description = ''
      Secretive is an app for storing and managing SSH keys in the Secure Enclave. It is inspired by
      the sekey project, but rewritten in Swift with no external dependencies and with a handy
      native management app.
    '';
    homepage = "https://github.com/maxgoedjen/secretive";
    changelog = "https://github.com/maxgoedjen/secretive/releases";
    license = licenses.mit;
    platforms = [ "x86_64-darwin" ];
  };
}
