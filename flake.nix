{
  description = "Personal blog and portfolio for me";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05-small";
    beam-overlay.url = "github:zeeetech/beam-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    beam-overlay,
    ...
  }: let
    system = "aarch64-darwin";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [beam-overlay.overlays.default];
    };
    toolchain = pkgs.beam-overlay.mkToolchain {
      elixir.version = "1.20.5";
      erlang-otp.version = "29.1.2";
    };
  in {
    nixosModules = {
      zoeyrinha-web = {
        imports = [
          beam-overlay.nixosModules.beam-containers
          ./nix/module.nix
        ];
      };
      default = self.nixosModules.zoeyrinha-web;
    };

    checks = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"] (system: let
      linuxPkgs = import nixpkgs {inherit system;};
    in {
      nixos-module = import ./nix/module-check.nix {
        pkgs = linuxPkgs;
        module = self.nixosModules.zoeyrinha-web;
      };
    });

    devShells.${system}.default = pkgs.mkShell {
      packages = [toolchain];
    };
  };
}
