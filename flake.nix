{
  inputs = {
    # nixpkgs.url = "nixpkgs-unstable";
    # systems.url = "github:nix-systems/default";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system:
          f system (
            import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            }
          )
        );
    in
    {
      packages = eachSystem (
        _system: pkgs: {
        }
      );

      devShells = eachSystem (
        _system: pkgs: {
          default = pkgs.mkShell {
            packages = [
              pkgs.vscode
            ];
          };
        }
      );
    };
}
