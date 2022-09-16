{
  description = "Write Markdown with code assist and intelligence in the comfort of your favourite editor.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ...}:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.buildDotnetModule rec {
          pname = "marksman";
          version = "2022-09-13";
          src = ./.;

          dotnet-sdk = pkgs.dotnetCorePackages.sdk_6_0;
          dotnet-runtime = pkgs.dotnetCorePackages.aspnetcore_6_0;

          nativeBuildInputs = with pkgs; [ git glibcLocales bintools ];

          runtimeDeps = with pkgs; [ mono ];

          nugetDeps = ./deps.nix;

          projectFile = "Marksman/Marksman.fsproj";

          doCheck = true;
          testProjectFile = "Tests/Tests.fsproj";

          meta = {
            homepage = "https://github.com/artempyanykh/marksman";
            description = "Write Markdown with code assist and intelligence in the comfort of your favourite editor. ";
            license = pkgs.lib.licenses.mit;
          };
        };
      }
    );
}