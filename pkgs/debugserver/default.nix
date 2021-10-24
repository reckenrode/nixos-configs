{ stdenv
, system
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "debugserver";
  version = "1.6.8";

  src = fetchurl {
    url = "https://github.com/vadimcn/vscode-lldb/releases/download/v${version}/codelldb-${system}.vsix";
    hash = if system == "aarch64-darwin"
      then "sha256-WxW12ycsaqfxrm3ty3JFKAitu8gK+D/iIUlJBPIbNaM="
      else "sha256-3jjW2/58l2JxaYs7YREFduhwTHpiCEoWuhNdgszrHpo=";
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
