# The blog release, built from source. Two build-time downloads are pinned to
# the build because the sandbox has no network:
#   - esbuild/tailwind: the hex wrappers read `config :..., :path`; a stanza
#     appended to the store copy of config.exs points them at the store.
#   - the markdown/highlighting NIFs (mdex_native, makeup_syntect), which ship
#     only as precompiled artifacts: seed rustler_precompiled's cache.
# Bump the NIF versions and hashes below together with mix.lock.
{
  lib,
  stdenv,
  beamPackages,
  esbuild,
  tailwindcss_4,
  fetchurl,
  runCommand,
  ...
}: let
  # nixpkgs has flip-flopped the beam override API (.overrideScope vs .extend)
  override = packages: f:
    if packages ? overrideScope
    then packages.overrideScope f
    else packages.extend f;

  beam = override beamPackages (_final: prev: {
    elixir = prev.elixir_1_20 or prev.elixir_1_19;
  });

  version =
    let
      line = lib.findFirst (l: lib.hasInfix "version:" l) "" (lib.splitString "\n" (builtins.readFile ../mix.exs));
      matched = builtins.match ".*\"([^\"]+)\".*" line;
    in
    if matched == null then "0.0.0" else builtins.head matched;

  src = lib.cleanSourceWith {
    src = ../.;
    filter = path: _type: let
      base = baseNameOf (toString path);
    in
      !(builtins.elem base [
        "_build"
        "deps"
        "tmp"
        ".git"
        ".expert"
        ".direnv"
        ".nix-mix"
        "result"
        "plts"
      ])
      && !(lib.hasSuffix "/priv/static/assets" (toString path))
      && base != "cache_manifest.json";
  };

  target =
    {
      x86_64-linux = "x86_64-unknown-linux-gnu";
      aarch64-darwin = "aarch64-apple-darwin";
    }
    .${stdenv.hostPlatform.system}
    or (throw "zoeyrinha-web: no precompiled NIFs pinned for ${stdenv.hostPlatform.system}");

  mdex_native = {
    "x86_64-unknown-linux-gnu" = {
      "libmdex_native_nif-v0.2.8-nif-2.15-x86_64-unknown-linux-gnu.so.tar.gz" = "sha256-ljI4QU6lprtFRZhsCcgl3/zXXpMn25q3MG+xqmy9TOw=";
      "libmdex_native_nif-v0.2.8-nif-2.15-x86_64-unknown-linux-gnu--legacy_cpu.so.tar.gz" = "sha256-Mmi5stNIeTFQX9rScJJNoF4xbFneRCE16NBKdVcoaaM=";
      "libmdex_native_nif-v0.2.8-nif-2.15-x86_64-unknown-linux-gnu--legacy_cpu_lumis.so.tar.gz" = "sha256-/iFKEMR36r6oLZ+JV8Bnxss1jPGGco9WW3gTj7AL4dI=";
      "libmdex_native_nif-v0.2.8-nif-2.15-x86_64-unknown-linux-gnu--legacy_cpu_syntect.so.tar.gz" = "sha256-6SbGn9KmjsjpL2lWcMSOR2QgcwUb+HnX5gV+5/c/ddE=";
      "libmdex_native_nif-v0.2.8-nif-2.15-x86_64-unknown-linux-gnu--lumis.so.tar.gz" = "sha256-R7nfBwgrkpwqQ8Ph3MHpUtdT2nt0q8/v2pH44M+7tsc=";
      "libmdex_native_nif-v0.2.8-nif-2.15-x86_64-unknown-linux-gnu--syntect.so.tar.gz" = "sha256-M6gaT8dofCH+LuQkw6QWd2cZ5UiZPPCvKFnfd3ULC4k=";
    };
    "aarch64-apple-darwin" = {
      "libmdex_native_nif-v0.2.8-nif-2.15-aarch64-apple-darwin.so.tar.gz" = "sha256-OTjknF3eGpJgO3l10kh1mMfp1U7l1/RITNgTzK+l2Q0=";
      "libmdex_native_nif-v0.2.8-nif-2.15-aarch64-apple-darwin--lumis.so.tar.gz" = "sha256-GOMbj9WESxsE29bE3g3h16q5i/ky6Km35ekYl/oTuaI=";
      "libmdex_native_nif-v0.2.8-nif-2.15-aarch64-apple-darwin--syntect.so.tar.gz" = "sha256-UU809llZ9YgiXkFa2x0ElTX/7KwQgxGlxadXYjXqKvw=";
    };
  };

  makeup_syntect = {
    "x86_64-unknown-linux-gnu" = {
      "libmakeup_syntect-v0.1.4-nif-2.15-x86_64-unknown-linux-gnu.so.tar.gz" = "sha256-5ZlXYQqK/+aaslzUNXTXutSv5oYOec1X+nBXSW4ntyo=";
    };
    "aarch64-apple-darwin" = {
      "libmakeup_syntect-v0.1.4-nif-2.15-aarch64-apple-darwin.so.tar.gz" = "sha256-IMUDGWWjJa4QzynYXmXWfVwAgMkt2nJhcfzJ7xTn7tk=";
    };
  };

  rustlerCache = import ./rustler-cache.nix {inherit lib fetchurl runCommand;} {
    deps = [
      {
        url = "https://github.com/leandrocp/mdex_native/releases/download/v0.2.8";
        files = mdex_native.${target};
      }
      {
        url = "https://github.com/elixir-makeup/makeup_syntect/releases/download/v0.1.4";
        files = makeup_syntect.${target};
      }
    ];
  };
in
  beam.mixRelease {
    pname = "zoeyrinha-web";
    inherit version src;

    # One fixed-output derivation for the hex deps, pinned by hash. Bumping
    # mix.lock changes the hash; the first build prints the one to paste here.
    mixFodDeps = beam.fetchMixDeps {
      pname = "zoeyrinha-web-deps";
      inherit version src;
      hash = "sha256-9PPLaKDiSMSjcBGwE8jp56kh06VpRe7SR/SPob5bYCk=";
    };

    env = {
      ESBUILD_BINARY_PATH = "${esbuild}/bin/esbuild";
      TAILWIND_BINARY_PATH = "${tailwindcss_4}/bin/tailwindcss";
      RUSTLER_PRECOMPILED_GLOBAL_CACHE_PATH = "${rustlerCache}";
    };

    postPatch = ''
      cat >> config/config.exs <<'EOF'

# Injected by Nix: store binaries and the seeded NIF cache, since the sandbox
# has no network.
if path = System.get_env("ESBUILD_BINARY_PATH"), do: config(:esbuild, path: path, version_check: false)
if path = System.get_env("TAILWIND_BINARY_PATH"), do: config(:tailwind, path: path, version_check: false)
EOF
    '';

    # assets are a prod step nixpkgs' mixRelease does not run; write them before
    # installPhase copies priv/static into the release
    postBuild = "mix assets.deploy";

    # the release script reads a cookie unconditionally; the blog is a single
    # node, so distribution is off and the cookie only satisfies the script
    postInstall = ''
      for env in "$out"/releases/*/env.sh; do
        cat >> "$env" <<'EOF'

export RELEASE_DISTRIBUTION="none"
export RELEASE_COOKIE="zoeyrinha-web"
EOF
      done

      # env.sh.eex may compute RELEASE_NODE from $(hostname), which is not on
      # the service PATH; distribution is off, so pin any node to loopback.
      sed -i 's/\$(hostname)/127.0.0.1/g' "$out"/releases/*/env.sh
    '';

    meta = {
      description = "Personal blog and portfolio for zoedsoupe";
      homepage = "https://github.com/zoedsoupe/zoeyrinha-web";
      platforms = lib.platforms.unix;
    };
  }
