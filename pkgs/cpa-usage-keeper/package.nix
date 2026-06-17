{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  glibc,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cpa-usage-keeper";
  version = "1.11.1";

  src = fetchurl {
    url = "https://github.com/Willxup/cpa-usage-keeper/releases/download/v${finalAttrs.version}/cpa-usage-keeper_v${finalAttrs.version}_linux_amd64.tar.gz";
    hash = "sha256-fzLO1ZcIcXgS9/+JEqZqyJcfIPH8fjj5oo5Zm3SMbOQ=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ glibc ];

  sourceRoot = "cpa-usage-keeper_v${finalAttrs.version}_linux_amd64";

  installPhase = ''
    runHook preInstall

    install -Dm755 cpa-usage-keeper "$out/bin/cpa-usage-keeper"
    for f in .env.example README.md README.en.md; do
      [ -f "$f" ] && install -Dm644 "$f" "$out/share/doc/cpa-usage-keeper/$f"
    done
    install -Dm644 LICENSE "$out/share/licenses/cpa-usage-keeper/LICENSE"

    runHook postInstall
  '';

  meta = {
    description = "Persistent CLIProxyAPI usage collector and dashboard";
    homepage = "https://github.com/Willxup/cpa-usage-keeper";
    changelog = "https://github.com/Willxup/cpa-usage-keeper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "cpa-usage-keeper";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
