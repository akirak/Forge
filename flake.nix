{
  inputs = {
    # nixpkgs.url = "nixpkgs-unstable";
    # systems.url = "github:nix-systems/default";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
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
        _system: pkgs:
        let
          forge = pkgs.callPackage ./nix/forge.nix {
            racketDeps = pkgs.callPackage ./nix/racket-deps.nix { };
          };
        in
        {
          default = forge;
          inherit forge;
        }
      );

      devShells = eachSystem (
        system: pkgs: {
          examples = pkgs.mkShell {
            packages = [
              pkgs.vscode
              self.packages.${system}.default
            ];
          };
        }
      );
    };
}
