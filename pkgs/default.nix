pkgs:

{
  crossover = pkgs.callPackage ./crossover {};
  debugserver = pkgs.callPackage ./debugserver {};
  finalfantasyxiv = pkgs.callPackage ./finalfantasyxiv {};
  netnewswire = pkgs.callPackage ./netnewswire {};
  ocr-documents = pkgs.callPackage ./ocr-documents {};
  pathofexile = pkgs.callPackage ./pathofexile {};
  secretive = pkgs.callPackage ./secretive {};
}
