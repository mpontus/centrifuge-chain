{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs;
    [ rustup openssl clang pkg-config ] ++ (lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ]);
  LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
  PROTOC = "${pkgs.protobuf}/bin/protoc";
  shellHook = ''
    ${./scripts/init.sh} install-toolchain
  '';
}
