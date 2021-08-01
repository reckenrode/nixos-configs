{ stdenv
, coreutils
, fish
, gawk
, imagemagick7
, poppler_utils
, tesseract4
}:

stdenv.mkDerivation {
  pname = "ocr-documents";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin
    substitute $src/ocr-documents $out/bin/ocr-documents \
      --subst-var-by coreutils ${coreutils} \
      --subst-var-by fish ${fish} \
      --subst-var-by gawk ${gawk} \
      --subst-var-by imagemagick7 ${imagemagick7} \
      --subst-var-by poppler_utils ${poppler_utils} \
      --subst-var-by tesseract4 ${tesseract4}
    chmod a+x $out/bin/ocr-documents
  '';
}
