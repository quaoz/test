{
  config,
  self,
  lib,
  ...
}: let
  inherit (config.age) secrets;

  cfg = config.garden.services.nginx;
in {
  # TODO: quic, better acme
  options.garden.services.nginx = self.lib.mkServiceOpt "nginx" {
    inherit (config.garden) domain;
  };

  config = lib.mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;

      defaults = {
        email = "acme@${cfg.domain}";

        dnsProvider = "cloudflare";
        credentialFiles.CF_DNS_API_TOKEN_FILE = secrets.cloudflare-cert-api.path;
      };

      # TODO: don't use wildcard
      #       https://github.com/hawkw/flake/blob/b6f5854f24944489435f8f5fc0892ff5f44935e8/modules/nixos/profiles/nginx.nix#L60
      certs.${cfg.domain} = {
        extraDomainNames = ["*.${cfg.domain}"];
      };
    };

    users.users.nginx.extraGroups = ["acme"];

    services.nginx = {
      enable = true;
      statusPage = true;

      recommendedTlsSettings = true;
      recommendedBrotliSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      experimentalZstdSettings = true;

      sslCiphers = "EECDH+aRSA+AESGCM:EDH+aRSA:EECDH+aRSA:+AES256:+AES128:+SHA1:!CAMELLIA:!SEED:!3DES:!DES:!RC4:!eNULL";
      sslProtocols = "TLSv1.3 TLSv1.2";
    };
  };
}
