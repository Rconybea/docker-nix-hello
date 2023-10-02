{
  description = "hello world";

  # dependencies
  inputs = rec {
    nixpkgs.url = "github:nixos/nixpkgs/23.05";
  };

  # see also ~/public_html/flake.nix

  outputs = { self, nixpkgs } :
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      hello_deriv = pkgs.writeShellScriptBin "entrypoint.sh" ''
        echo "Hello $1"
        time=$(date)
        echo "time=$time" >> $GITHUB_OUTPUT
      '';

      docker_hello_deriv =
        pkgs.dockerTools.buildLayeredImage {
          name = "docker-nix-hello";
          tag = "v2";
          contents = self.packages.${system}.hello;

          config = {
            Cmd = [ "/bin/entrypoint.sh" ];
            WorkingDir = "/";
          };
        };

    in rec {
      packages.${system} = {
        default = docker_hello_deriv;

        hello = hello_deriv;
        docker_hello = docker_hello_deriv;

        # for example,  github actions creates container with --entrypoint "tail",
        # so container must provide executable with that name in $PATH
        #
        coreutils = pkgs.coreutils;
      };
    };
}
