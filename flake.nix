{
  description = "Nix package for centrifuge-chain";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};

        cargoTOML = builtins.fromTOML (builtins.readFile ./Cargo.toml);

        name = cargoTOML.package.name;
        # This is the program version.
        version = cargoTOML.package.version;

        fenix = inputs.fenix.packages.${system};
        toolchain = fenix.fromToolchainFile {
          file = ./rust-toolchain.toml;
          sha256 = "sha256-CNMj0ouNwwJ4zwgc/gAeTYyDYe0botMoaj/BkeDTy4M=";
        };
        craneLib = (inputs.crane.mkLib pkgs).overrideToolchain toolchain;

        # srcFilter is used to keep out of the build non-source files,
        # so that we only trigger a rebuild when necessary.
        srcFilter = src:
          let
            isGitIgnored = inputs.gitignore.lib.gitignoreFilter src;

            ignoreList = [
              ".dockerignore"
              ".envrc"
              ".github"
              ".travis.yml"
              "CODE_OF_CONDUCT.md"
              "README.md"
              "ci"
              "cloudbuild.yaml"
              "codecov.yml"
              "docker-compose.yml"
              "rustfmt.toml"
            ];
          in path: type:
          isGitIgnored path type
          && builtins.all (name: builtins.baseNameOf path != name) ignoreList;
        commonAttrs = {
          src = pkgs.lib.cleanSourceWith {
            src = ./.;
            filter = srcFilter ./.;
            name = "${name}-source";
          };

          nativeBuildInputs = with pkgs; [ clang pkg-config ];
          buildInputs = with pkgs;
            [ openssl ] ++ (lib.optionals stdenv.isDarwin [
              darwin.apple_sdk.frameworks.Security
              darwin.apple_sdk.frameworks.SystemConfiguration
            ]);

          LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
          PROTOC = "${pkgs.protobuf}/bin/protoc";

          doCheck = false;
        };
        # Build dependencies only to cache them in CI
        cargoArtifacts = craneLib.buildDepsOnly commonAttrs;
      in rec {
        defaultPackage = craneLib.buildPackage (commonAttrs // {
          pname = name;
          inherit version cargoArtifacts;
        });

        packages.fastRuntime = defaultPackage.overrideAttrs
          (base: { buildFeatures = [ "fast-runtime" ]; });

        # Docker image package doesn't work on Darwin Archs
        packages.dockerImage = pkgs.dockerTools.buildLayeredImage {
          name = "centrifugeio/${name}";
          tag = "${version}-nix-do-not-use"; # todo remove suffix once verified
          # This uses the date of the last commit as the image creation date.
          created = builtins.substring 0 8 inputs.self.lastModifiedDate;

          contents = [ pkgs.busybox inputs.self.defaultPackage.${system} ];

          config = {
            ExposedPorts = {
              "30333/tcp" = { };
              "9933/tcp" = { };
              "9944/tcp" = { };
            };
            Volumes = { "/data" = { }; };
            Entrypoint = [ "centrifuge-chain" ];
          };

        };

        packages.dockerImageFastRuntime = packages.dockerImage.overrideAttrs
          (base: {
            tag =
              "test-${version}-nix-do-not-use"; # todo remove suffix once verified
            contents = [ pkgs.busybox packages.fastRuntime ];
          });
      });
}
