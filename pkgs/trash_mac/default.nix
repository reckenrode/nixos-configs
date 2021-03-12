{ lib, stdenv, fetchFromGitHub, darwin, perl }:
stdenv.mkDerivation rec {
  pname = "trash_mac";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "ali-rantakari";
    repo = "trash";
    rev = "v${version}";
    sha256 = "1d3rc03vgz32faj7qi18iiggxvxlqrj9lsk5jkpa9r1mcs5d89my";
  };

  buildInputs = with darwin.apple_sdk.frameworks; [ Cocoa ScriptingBridge ];
  nativeBuildInputs = [ perl ]; 

  patches = [ ./files/disable_x86.diff ];

  buildPhase = ''
    make trash trash.1
  '';

  installPhase = ''
    install -d -m 0755 $out/bin
    install -d -m 0755 $out/share/man/man1
    install -m 0755 trash $out/bin/trash
    install -m 0644 trash.1 $out/share/man/man1/trash.1
  '';

  meta = with lib; {
    description = "This is a small command-line program for OS X that moves files or folders to the trash.";
    homepage = "https://github.com/ali-rantakari/trash";
    license = licenses.mit;
    platform = platforms.darwin;
  };
}
