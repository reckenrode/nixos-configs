_: prev:

prev.weechat-unwrapped.overrideAttrs (old: {
  buildInputs = builtins.filter (dep: dep != prev.darwin.libresolv) old.buildInputs;
})
