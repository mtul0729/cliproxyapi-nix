{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "cliproxyapi";
  version = "7.2.94";

  src = fetchFromGitHub {
    owner = "router-for-me";
    repo = "CLIProxyAPI";
    rev = "v${version}";
    hash = "sha256-f0aBi/Pz+Dyd3X1V0qVg71GSxTKli1WbWI45e2dWRK4=";
  };

  vendorHash = "sha256-xirNOpnPVwe/TqEYkHHLMWREajosaisBazvy8rFEIak=";
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
