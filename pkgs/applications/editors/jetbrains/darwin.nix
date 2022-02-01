{
  lib,
  stdenvNoCC,
  undmg,
  ...
}:

{
  meta,
  name,
  product,
  productShort ? product,
  src,
  version,
  ...
}:

with lib;

let
  loname = toLower productShort;
in
  stdenvNoCC.mkDerivation {
    inherit meta src version;
    desktopName = product;
    installPhase = ''
      runHook preInstall
      APP_DIR="$out/Applications/${product}.app"
      mkdir -p "$APP_DIR"
      cp -Tr "${product}.app" "$APP_DIR"
      mkdir -p "$out/bin"
      cat << EOF > "$out/bin/${loname}"
      open -n "$APP_DIR" --args "$@"
      EOF
      chmod +x "$out/bin/${loname}"
      runHook postInstall
    '';
    nativeBuildInputs = [ undmg ];
    pname = concatStringsSep "-" (init (splitString "-" name));
    sourceRoot = ".";
  }
