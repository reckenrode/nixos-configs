{ stdenv
, coreutils
, fish
, gnused
, sane-backends
, tesseract4
}:

stdenv.mkDerivation {
  pname = "ocr-documents";
  version = "2.0.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin
    substitute $src/ocr-documents $out/bin/ocr-documents \
      --subst-var-by coreutils ${coreutils} \
      --subst-var-by fish ${fish} \
      --subst-var-by gnused ${gnused} \
      --subst-var-by sane-backends ${sane-backends} \
      --subst-var-by tesseract4 ${tesseract4}
    chmod a+x $out/bin/ocr-documents
  '';
}
