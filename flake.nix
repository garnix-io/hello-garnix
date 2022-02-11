{
  description = "A very basic flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-darwin" ] (system:
      { packages =
        { hello-garnix =
            let pkgs = nixpkgs.legacyPackages.${system};
            in pkgs.stdenv.mkDerivation {
                name = "hello-garnix";

                unpackPhase = ":";

                buildPhase = ''
                  echo "Just building some things, don't mind me"
                  cat > an-executable <<EOF
                  echo "Hello from an executable!"
                  EOF
                  chmod +x an-executable
                '';

                checkPhase = ''
                  echo "Looking around to see if anything is amiss.."
                  OUTPUT=$(./an-executable)
                  if [ "$OUTPUT" != "Hello rom an executable!" ]; then
                    echo "Test failed!"
                    exit 1
                  fi
                '';

                installPhase = ''
                  mkdir -p $out/bin
                  cp an-executable $out/bin/
                '';


                doCheck = true;

              };
        };
      }
  );
}
