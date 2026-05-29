{
  description = "CLIProxyAPI – standalone Nix package (from source)";

  nixConfig = {
    extra-substituters = [ "https://mtul.cachix.org" ];
    extra-trusted-public-keys = [
      "mtul.cachix.org-1:WEuapLtfyNPLkcCbwQh3jLxVwEwQNcDXhru9lbuhDlo="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    {
      overlays.default = final: prev: {
        cliproxyapi = final.callPackage ./pkgs/cliproxyapi/package.nix { };
      };

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          cliproxyapi = pkgs.callPackage ./pkgs/cliproxyapi/package.nix { };
        in
        {
          inherit cliproxyapi;
          default = cliproxyapi;
        }
      );
    };
}
