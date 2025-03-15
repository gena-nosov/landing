{
  stdenv,
  lib,
  gnused,
  fixRelativeLinks ? true,
  fixedRelativeLinksSrc ? "https://doom2d.org",
}:
stdenv.mkDerivation {
  name = "doom2d-landing";
  src = ./..;

  nativeBuildInputs = lib.optionals fixRelativeLinks [
    gnused
  ];

  # Fix up relative links like /forum.php
  # This is very crude. Just replaces href="/ with href="${fixedRelativeLinksSrc}/
  buildPhase = lib.optionalString fixRelativeLinks ''
    sed -i 's#href="\/#href="${fixedRelativeLinksSrc}\/#g' index.html
  '';

  installPhase = ''
    mkdir -p $out
    mv * $out
  '';
}
