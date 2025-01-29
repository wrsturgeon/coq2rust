{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      flake-utils,
      nix-filter,
      nixpkgs,
    }:
    let
      pname = "rocq2rust";
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        ml-pkgs = pkgs.ocamlPackages;

        deps-native =
          (with pkgs; [
            dune_3
          ])
          ++ (with ml-pkgs; [
            ocaml
            ocamlformat
          ]);
        deps-propagated = with ml-pkgs; [
          findlib
          zarith
        ];

        env = {
          DUNEOPT = "--display=short";
        };

      in
      {
        packages = {
          build = pkgs.stdenv.mkDerivation (
            {
              name = "${pname}-build";
              src = nix-filter {
                root = ./.;
                include = [
                  ./Makefile
                  ./dune
                  ./dune-project
                  ./tools
                  ./lib
                  ./boot
                  ./config
                  ./clib
                  ./dev
                  ./plugins
                  ./vernac
                  ./parsing
                  ./interp
                  ./tactics
                  ./printing
                  ./proofs
                  ./gramlib
                  ./pretyping
                  ./engine
                  ./library
                  ./kernel
                  ./toplevel
                  ./stm
                  ./sysinit
                  ./theories
                  ./user-contrib
                  ./topbin
                  ./coqpp
                ];
              };

              configurePhase = ":";
              buildPhase = "make world";
              installPhase = ''
                mkdir -p ''${out}
                mv ./_build ''${out}/
              '';

              nativeBuildInputs = deps-native;
              propagatedBuildInputs = deps-propagated;

              DUNEOPT = "--display=short";
            }
            // env
          );
          default = pkgs.stdenv.mkDerivation (
            {
              name = pname;
              src = builtins.path {
                path = ./.;
                name = "no-src";
                filter = _: _: false;
              };
              installPhase = ''
                mkdir -p ''${out}
                cd ${self.packages.${system}.build}/_build/install/default
                ls | xargs -I{} cp -Lr {} ''${out}/
              '';
            }
            // env
          );
        };

        devShells.default = pkgs.mkShell (
          { packages = deps-native ++ deps-propagated ++ (with ml-pkgs; [ ocamllsp ]); } // env
        );
      }
    );
}
