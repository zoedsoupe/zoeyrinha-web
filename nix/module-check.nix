{
  pkgs,
  module,
}: let
  evaluated = import (pkgs.path + "/nixos/lib/eval-config.nix") {
    system = null;
    modules = [
      module
      {
        nixpkgs.hostPlatform = pkgs.stdenv.hostPlatform.system;

        fileSystems."/" = {
          device = "/dev/disk/by-label/nixos";
          fsType = "ext4";
        };
        boot.loader.grub.device = "nodev";
        system.stateVersion = "26.05";

        services.beam.containers.zoeyrinha-web = {
          enable = true;
          image = "ghcr.io/zoedsoupe/zoeyrinha-web:0.1.0";
          uid = 33333;
          gid = 33334;
          port = 4010;
          environmentFiles = ["/etc/phoenix/blog.env"];
        };
        services.zoeyrinha-web.hostname = "zoedsoupe.zeetech.io";
      }
    ];
  };

  config = evaluated.config;
  container = config.virtualisation.oci-containers.containers.zoeyrinha-web;
in
  assert container.user == "33333:33334";
  assert container.environment.PHX_SERVER == "true";
  assert container.environment.PHX_HOST == "zoedsoupe.zeetech.io";
  assert container.environment.PORT == "4010";
  assert container.environment.HOME == "/data";
  assert container.environmentFiles == ["/etc/phoenix/blog.env"];
  assert container.volumes == ["/var/lib/zoeyrinha-web:/data"];
  assert container.ports == ["127.0.0.1:4010:4010"];
  assert config.users.users.zoeyrinha-web.uid == 33333;
  assert config.users.groups.zoeyrinha-web.gid == 33334;
  assert !(config.services.zoeyrinha-web ? image);
  assert !(config.services.zoeyrinha-web ? enable);
    pkgs.runCommand "zoeyrinha-web-module-check" {} "touch $out"
