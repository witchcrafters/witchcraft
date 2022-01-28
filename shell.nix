let
  nixpkgs = import (fetchTarball {
    # Run `cachix use jechol` to use compiled binary cache.
    url = "https://github.com/jechol/nixpkgs/archive/21.11-otp24-no-jit.tar.gz";
    sha256 = "sha256:1lka707hrnkp70vny99m9fmp4a8136vl7addmpfsdvkwb81d1jk9";
  }) { };
  platform = if nixpkgs.stdenv.isDarwin then [
    nixpkgs.darwin.apple_sdk.frameworks.CoreServices
    nixpkgs.darwin.apple_sdk.frameworks.Foundation
  ] else if nixpkgs.stdenv.isLinux then
    [ nixpkgs.inotify-tools ]
  else
    [ ];
in nixpkgs.mkShell {
  buildInputs = with nixpkgs;
    [
      # OTP
      erlang
      elixir
    ] ++ platform;
}
