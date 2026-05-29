{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  glibc,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cpa-usage-keeper";
  version = "1.8.6";

  src = fetchurl {
    url = "https://github.com/Willxup/cpa-usage-keeper/releases/download/v${finalAttrs.version}/cpa-usage-keeper_v${finalAttrs.version}_linux_amd64.tar.gz";
    hash = "sha256-1ffcj71IQEMQ/M7TM72WIAuigNcpVuq8O2b2DjrcGSM=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ glibc ];

  sourceRoot = "cpa-usage-keeper_v${finalAttrs.version}_linux_amd64";

  installPhase = ''
    runHook preInstall

    install -Dm755 cpa-usage-keeper "$out/bin/cpa-usage-keeper"
    install -Dm644 .env.example "$out/share/doc/cpa-usage-keeper/.env.example"
    install -Dm644 README.md "$out/share/doc/cpa-usage-keeper/README.md"
    install -Dm644 README.en.md "$out/share/doc/cpa-usage-keeper/README.en.md"
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
