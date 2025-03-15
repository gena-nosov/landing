{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {self, ...}:
    inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import inputs.nixpkgs {inherit system;};
    in rec {
      packages.landing = pkgs.callPackage ./landing.nix {};
      packages.default = packages.landing;
      apps.landing =
        inputs.flake-utils.lib.mkApp
        {
          drv = pkgs.writeShellScriptBin "pages" "${pkgs.python3}/bin/python3 -m http.server 8000 -d ${packages.landing}";
        };
      apps.default = apps.landing;
    });
}
