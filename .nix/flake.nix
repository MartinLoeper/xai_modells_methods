{
  description = "A Service which runs the hp-optimization";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix = {
      url = "github:nesto-software/poetry2nix-unstable/4f59c9a1cd7190ce8b5e1c9d4557f54ae967e765";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat, poetry2nix }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication mkPoetryEnv defaultPoetryOverrides;
      in
      {
        packages = {
          hp-tuning-entrypoint = mkPoetryApplication {
            projectDir = ./..;
            pyproject = ./../pyproject.toml;
            poetrylock = ./../poetry.lock;
            python = pkgs.python310;

            meta = with pkgs.lib; {
              homepage = "https://gitlab.nesto.app/nesto-software/data-science/running-services/hyperparameter_job_execution";
              description = "The entrypoint for hyperparameter tuning executions";
              license = licenses.unfree;
            };
          };
          default = self.packages.${system}.hp-tuning-entrypoint;
        };

        # enables use of `nix shell`
        devShells = {

          # build the app using poetry2nix and expose all build artifacts as a dev environment
          poetry-env =
            let
              envShell = mkPoetryEnv
                {
                  projectDir = ./..;
                  pyproject = ./../pyproject2.toml;
                  poetrylock = ./../poetry2.lock;
                  overrides = defaultPoetryOverrides.extend
                    (self: super: {
                      nesto-product-forecast = super.nesto-product-forecast.overridePythonAttrs
                        (
                          old: {
                            buildInputs = (old.buildInputs or [ ]) ++ [ self.poetry-core ];
                          }
                        );

                      pillow = super.pillow.override
                        {
                          preferWheel = true;
                        };
                    });
                };
            in
            envShell.env;

          # dev shell to run poetry manually
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              bashInteractive
              python310
              python310Packages.pip
              poetry
              cmake
              pkg-config # used by many setup.py scripts to locate libraries
              zlib # poetry dependency for pillow
              gfortran # scipy dependency
              openblas # scipy dependency
              stdenv.cc.cc.lib # libstdc++.so.6 and libgomp.so.1
              libgcc.lib
              gnat
              libjpeg # poetry dependency for pillow
              lapack # poetry dependency for scipy
              blas # poetry dependency for scipy
            ];

            SHELL = "${pkgs.zsh}/bin/zsh";

            shellHook = ''
              export SHELL="${pkgs.zsh}/bin/zsh"
              export NESTO_NIX_DEVSHELL=1;
              export PATH="$HOME/nesto/repos/nesto-software/data-science/running-services/hp-job-execution/scripts:$PATH"

              export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
                pkgs.libgcc.lib
              ]}
            '';
          };
        };
      }
    );
}

