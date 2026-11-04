{
  config,
  lib,
  ...
}: let
  cfg = config.services.zoeyrinha-web;
  container = config.services.beam.containers.zoeyrinha-web;
in {
  options.services.zoeyrinha-web.hostname = lib.mkOption {
    type = lib.types.str;
    example = "zoedsoupe.zeetech.io";
    description = "Public hostname used for absolute URLs.";
  };

  config = lib.mkMerge [
    {
      services.beam.containers.zoeyrinha-web.environment = {
        PHX_SERVER = "true";
        PHX_HOST = cfg.hostname;
        PORT = toString container.port;
      };
    }
    (lib.mkIf container.enable {
      assertions = [
        {
          assertion = container.port != null;
          message = "services.beam.containers.zoeyrinha-web.port must be set.";
        }
        {
          assertion = container.environmentFiles != [];
          message = "services.beam.containers.zoeyrinha-web.environmentFiles must provide SECRET_KEY_BASE.";
        }
      ];
    })
  ];
}
