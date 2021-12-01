{ stdenv
, fetchurl
, unzip
}:

let
  inherit (stdenv.hostPlatform) system;
in
stdenv.mkDerivation rec {
  pname = "debugserver";
  version = "1.6.10";

  src = fetchurl {
    url = "https://github.com/vadimcn/vscode-lldb/releases/download/v${version}/codelldb-${system}.vsix";
    hash = if system == "aarch64-darwin"
      then "sha256-3aElZtXzlWasqB/ZtUT6+J05QdRefP3Ze7ZJL4g+L5Y="
      else "sha256-rxe4DMv1/lfbMCkwKqvNCuBO0n0wtDndNPslG18BekI=";
  };

  buildInputs = [
    unzip
  ];

  unpackPhase = "unzip $src";

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 extension/lldb/bin/debugserver $out/bin
  '';
}
