{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "cliproxyapi";
  version = "7.1.36";

  src = fetchFromGitHub {
    owner = "router-for-me";
    repo = "CLIProxyAPI";
    rev = "v${version}";
    hash = "sha256-ZOLtogeNlwHafjF9QI13SBT52GWs6ED8dxZ1xfpzmrg=";
  };

  vendorHash = "sha256-AIue9XBsfsKGClRLB1DCME+36crapnOdQrEICFYG1a0=";
  subPackages = [ "cmd/server" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${version}"
  ];

  # Upstream release artifacts are already built and published from CI.
  doCheck = false;

  passthru.updateScript = nix-update-script {
    attrPath = "cliproxyapi";
    extraArgs = [
      "--version-regex"
      "^v(.*)$"
    ];
  };

  postInstall = ''
    mv "$out/bin/server" "$out/bin/cli-proxy-api"

    install -Dm644 config.example.yaml \
      "$out/share/doc/cliproxyapi/config.example.yaml"
  '';

  meta = {
    description = "OpenAI/Gemini/Claude/Codex compatible API proxy for CLI tools";
    homepage = "https://github.com/router-for-me/CLIProxyAPI";
    changelog = "https://github.com/router-for-me/CLIProxyAPI/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "cli-proxy-api";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = [ ];
  };
}
