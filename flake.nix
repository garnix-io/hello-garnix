{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.hello-garnix =
      let pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
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
            if [ "$OUTPUT" != "Hello from an executable!" ]; then
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


    defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello-garnix;

  };
}
