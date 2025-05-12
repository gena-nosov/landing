{
  stdenv,
  lib,
  gnused,
  envsubst,
  bash,
  fixRelativeLinks ? true,
  fixedRelativeLinksSrc ? "https://doom2d.org",
  languages ? ["en" "ru"],
}:
stdenv.mkDerivation {
  name = "doom2d-landing";
  src = ./..;

  nativeBuildInputs =
    lib.optionals fixRelativeLinks [
      gnused
    ]
    ++ [
      envsubst
      bash
    ];

  # Fix up relative links like /forum.php
  # This is very crude. Just replaces href="/ with href="${fixedRelativeLinksSrc}/
  buildPhase =
    lib.optionalString fixRelativeLinks ''
      sed -i 's#href="\/#href="${fixedRelativeLinksSrc}\/#g' index.html
    ''
    + (let
      mkLang = lang: ''
        mkdir -p ${lang}/
        ls nix
        pwd
        bash $(pwd)/nix/template.sh ./strings.${lang}.txt index.html > ${lang}/index.html
      '';
    in
      lib.concatStringsSep "\n" (lib.map mkLang languages));

  installPhase = let
    moveLang = lang: ''
      mv ${lang}/ $out/
      cp -r css/ vendor/ img/ js/ $out/${lang}/
    '';
    allLanguages = lib.concatStringsSep "\n" (lib.map moveLang languages);
  in ''
    mkdir -p $out/
    cp base.html $out/index.html
    ${allLanguages}
  '';
}
