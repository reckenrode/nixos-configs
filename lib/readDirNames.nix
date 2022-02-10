path:
let
  inherit (builtins) attrNames filter readDir;
  files = readDir path;
  isDirectory = name: files."${name}" == "directory";
in
filter isDirectory (attrNames files)
