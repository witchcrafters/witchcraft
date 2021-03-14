 let
  sources  = import ./nix/sources.nix;
  commands = import ./nix/commands.nix;

  nixos    = import sources.nixpkgs  {};
  darwin   = import sources.darwin   {};
  unstable = import sources.unstable {};

  pkgs  = if darwin.stdenv.isDarwin then darwin else nixos;
  tasks = commands {
    inherit pkgs;
    inherit unstable;
  };

  deps = {
    common =
      [  pkgs.niv
      ];

    elixir =
      [ unstable.elixir
      ];

    platform =
      if pkgs.stdenv.isDarwin then
        [ unstable.darwin.apple_sdk.frameworks.CoreServices
          unstable.darwin.apple_sdk.frameworks.Foundation
        ]
      else if pkgs.stdenv.isLinux then
        [ pkgs.inotify-tools
        ]
      else
        [];
  };
in

pkgs.mkShell {
  name = "Quark";
  nativeBuildInputs = builtins.concatLists [
    deps.common 
    deps.elixir
    deps.platform
    tasks
  ];
}
