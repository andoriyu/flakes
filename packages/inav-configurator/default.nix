{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
  wrapGAppsHook3,
  gsettings-desktop-schemas,
  gtk3,
  glib,
  nss,
  nspr,
  atk,
  at-spi2-atk,
  libdrm,
  expat,
  libxcb,
  libxkbcommon,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libgbm,
  pango,
  cairo,
  alsa-lib,
  dbus,
  cups,
  libxshmfence,
  unzip,
  udev,
  libGL,
}:
stdenv.mkDerivation rec {
  pname = "inav-configurator";
  version = "9.0.0-RC3";

  src = fetchurl {
    url = "https://github.com/iNavFlight/inav-configurator/releases/download/${version}/INAV-Configurator_linux_x64_9.0.0.zip";
    hash = "sha256-PAzGgaxnFk5BgHqAu33KunlnSEhpAKuSXsNajO2HSS4=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/iNavFlight/inav-configurator/bf3fc89e6df51ecb83a386cd000eebf16859879e/images/inav_icon_128.png";
    hash = "sha256-/EMleYuNk6s3lg4wYwXGUSLbppgmXrdJZkUX9n8jBMU=";
  };

  sourceRoot = ".";

  # Remove unneeded prebuilds for other architectures and musl
  postUnpack = ''
    find . -path "*/prebuilds/linux-arm*" -delete
    find . -path "*/prebuilds/android-*" -delete
    find . -path "*/prebuilds/win32-*" -delete
    find . -path "*/prebuilds/darwin-*" -delete
    find . -name "*musl*" -delete
  '';

  nativeBuildInputs = [
    unzip
    copyDesktopItems
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    gsettings-desktop-schemas
    gtk3
    glib
    nss
    nspr
    atk
    at-spi2-atk
    libdrm
    expat
    libxcb
    libxkbcommon
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libgbm
    pango
    cairo
    alsa-lib
    dbus
    cups
    libxshmfence
    libGL
  ];

  runtimeDependencies = [
    udev
  ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin \
             $out/opt/${pname}

    cp -r "INAV Configurator-linux-x64"/* $out/opt/${pname}/
    install -m 444 -D $icon $out/share/icons/hicolor/128x128/apps/${pname}.png

    chmod +x $out/opt/${pname}/inav-configurator

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper $out/opt/${pname}/inav-configurator $out/bin/${pname} \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+--ozone-platform-hint=auto}"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      comment = "iNavFlight configuration tool";
      desktopName = "iNav Configurator";
      genericName = "Flight controller configuration tool";
      categories = ["Utility"];
    })
  ];

  meta = with lib; {
    description = "iNav flight control system configuration tool (9.0 RC)";
    mainProgram = "inav-configurator";
    longDescription = ''
      A crossplatform configuration tool for the iNav flight control system.
      Various types of aircraft are supported by the tool and by iNav, e.g.
      quadcopters, hexacopters, octocopters and fixed-wing aircraft.

      This is the 9.0 Release Candidate version.
    '';
    homepage = "https://github.com/iNavFlight/inav-configurator";
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    license = licenses.gpl3Only;
    platforms = ["x86_64-linux"];
  };
}
