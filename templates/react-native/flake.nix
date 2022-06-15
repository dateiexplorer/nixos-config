{
  description = "A basic React Native development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      android = {
        versions = {
          tools = "26.1.1";
          platformTools = "31.0.2";
          buildTools = "30.0.2";
          ndk = [ "22.1.7171670" "21.3.6528147" ];
          cmake = "3.18.1";
          emulator = "30.6.3";
        };

        platforms = [ "28" "29" "30" ];
        abis = [ "armeabi-v7a" "arm64-v8a" ];
        extras = [ "extras;google;gcm" ];
      };

      pkgs = import nixpkgs {
        inherit system;

        overlays = [ self.overlay ];
        config.android_sdk.accept_license = true;
      };
    in
    {
      overlay = final: prev: with final.pkgs; {
        sdk = (pkgs.androidenv.composeAndroidPackages {
          toolsVersion = android.versions.tools;
          platformToolsVersion = android.versions.platformTools;
          buildToolsVersions = [ android.versions.buildTools ];
          platformVersions = android.platforms;

          includeEmulator = false;
          includeSources = false;
          includeSystemImages = false;

          systemImageTypes = [ "google_apis_playstore" ];
          abiVersions = android.abis;
          cmakeVersions = [ android.versions.cmake ];

          includeNDK = false;
          useGoogleAPIs = false;
          useGoogleTVAddOns = false;
        });
      }

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
