{
  description = "A basic Rust development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      # Use the devShell for a specific system as mentioned in the NixOS Wiki.
      devShell."${system}" = pkgs.mkShell {
        buildInputs = with pkgs; [
          cargo
          rustc
          rustfmt
        ];

        # Certain Rust tools wont' work without this
        # This can also be fixed by using oxalica/rust-overlay and specifying
        # the rust-src extension.
        # https://nixos.wiki/wiki/Rust

        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      };
    };
}
