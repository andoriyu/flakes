{ lib, stdenv, fetchurl, writeScript, curl, jq, common-updater-scripts, plex, plexRaw }:

let
  version = "1.42.1.10060-4e8b05daf";
  sources = {
    x86_64-linux = fetchurl {
      url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
      sha256 = "3a822dbc6d08a6050a959d099b30dcd96a8cb7266b94d085ecc0a750aa8197f4";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_arm64.deb";
      sha256 = "f10c635b17a8aedc3f3a3d5d6cad8dff9e7fb534384d601eb832a3e3de91b0e7";
    };
  };

  plexRaw' = plexRaw.overrideAttrs (_: {
    inherit version;
    name = "plexmediaserver-${version}";
    src = sources.${stdenv.hostPlatform.system};
  });

  base = plex.override { plexRaw = plexRaw'; };

in
base.overrideAttrs (old: rec {
  pname = "plexmediaserver-plexpass";
  inherit version;
  name = "${pname}-${version}";

  passthru = old.passthru // {
    updateScript = writeScript "plex-pass-updater" ''
      #!${stdenv.shell}
      set -eu -o pipefail
      PATH=${lib.makeBinPath [curl jq common-updater-scripts]}:$PATH

      plexApiJson=$(curl -sS https://plex.tv/api/downloads/5.json?channel=plexpass)
      latestVersion="$(echo $plexApiJson | jq .computer.Linux.version | tr -d '\"\n')"

      for platform in ${lib.concatStringsSep " " old.meta.platforms}; do
        arch=$(echo $platform | cut -d '-' -f1)
        dlUrl="$(echo $plexApiJson | jq --arg arch "$arch" -c '.computer.Linux.releases[] | select(.distro == "debian") | select(.build | contains($arch)) .url' | tr -d '\"\n')"
        latestSha="$(nix-prefetch-url $dlUrl)"
        update-source-version plex-pass "$latestVersion" "$latestSha" --system=$platform --ignore-same-version
      done
    '';
  };

  meta = old.meta // {
    description = "Plex Media Server (Plex Pass)";
  };
})
