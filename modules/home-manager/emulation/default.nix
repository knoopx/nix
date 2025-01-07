{
  pkgs,
  config,
  ...
}: let
  libretro-db_tool = pkgs.stdenv.mkDerivation rec {
    name = "libretro-db_tool";
    version = "1.19.1";

    src = pkgs.fetchFromGitHub {
      owner = "libretro";
      repo = "RetroArch";
      rev = "v${version}";
      hash = "sha256-NVe5dhH3w7RL1C7Z736L5fdi/+aO+Ah9Dpa4u4kn0JY=";
    };

    preConfigure = "cd libretro-db";
    installPhase = "install -D libretrodb_tool $out/bin/libretrodb_tool";
  };

  # retool = pkgs.retool.overrideAttrs (origAttrs: {
  #   postFixup =
  #     origAttrs.postFixup
  #     + ''
  #       ln -s ${config.home.homeDirectory}/.config/retool $out/bin/config
  #       ln -s ${config.home.homeDirectory}/.local/share/retool/datafile.dtd $out/bin/datafile.dtd
  #       ln -s ${config.home.homeDirectory}/.local/share/retool/clonelists $out/bin/clonelists
  #       ln -s ${config.home.homeDirectory}/.local/share/retool/metadata $out/bin/metadata
  #     '';
  # });

  metadata = {
    retool = pkgs.stdenvNoCC.mkDerivation {
      name = "emulation-metadata-retool";

      phases = ["installPhase"];

      src = pkgs.fetchurl {
        url = "https://github.com/unexpectedpanda/retool-clonelists-metadata.git";
        sha256 = "";
      };

      installPhase = ''
        mkdir -p $out/share/meta/retool
      '';
    };

    es-de = pkgs.stdenvNoCC.mkDerivation {
      name = "emulation-metadata-es-de";
      phases = ["installPhase"];
      src = pkgs.fetchurl {
        url = "https://gitlab.com/es-de/emulationstation-de/-/raw/d68bdd070e247a4a3432d8ecc1b8773269acefb3/resources/systems/linux/es_systems.xml";
        sha256 = "sha256-C+powj9iiDUj//+RbsYVwIV3ZZh/6EtYhalNz/WXeTM=";
      };
      buildInputs = with pkgs; [dasel];
      installPhase = ''
        mkdir -p $out/share/emulation-metadata/es-de
        cat $src | dasel -r xml "systemList.system.all().mapOf(name,name,fullname,fullname,platform,platform,extension,extension).merge()" \
            -w csv > $out/share/emulation-metadata/es-de/systems.csv
      '';
    };

    launchbox = pkgs.stdenvNoCC.mkDerivation {
      name = "emulation-metadata-launchbox";
      buildInputs = with pkgs; [dasel];
      installPhase = ''
        mkdir -p $out/share/emulation-metadata/launchbox/xml
        cp -r *.xml $out/share/emulation-metadata/launchbox/xml

        cat Platforms.xml | dasel -r xml -w csv "LaunchBox.Platform" > $out/share/emulation-metadata/launchbox/systems.csv
        cat Platforms.xml | dasel -r xml -w csv "LaunchBox.PlatformAlternateName" > $out/share/emulation-metadata/launchbox/system_aliases.csv
        cat Metadata.xml | sed -e 's/&#xC;//g' | dasel -r xml -w csv  "LaunchBox.Game" > $out/share/emulation-metadata/launchbox/games.csv
      '';
      src = fetchTarball {
        url = "http://gamesdb.launchbox-app.com/Metadata.zip";
        sha256 = "sha256:1m6xy2kyala5c586f2sksn2ng9gs9mad0njqgd0ssmasnrabpdzr";
      };
    };

    libretro = pkgs.stdenvNoCC.mkDerivation {
      name = "emulation-metadata-libretro";

      installPhase = ''
        mkdir -p $out/share/emulation-metadata/libretro
        cp -r $src/{cht,dat,metadat,rdb} $out/share/emulation-metadata/libretro
      '';

      src = pkgs.fetchFromGitHub {
        owner = "libretro";
        repo = "libretro-database";
        rev = "49acc074cc09d1b9a1bfb67e5c490b10c443ff89";
        hash = "sha256-oZFuwBTOffmBTYKn9LSfIulR5gjOZ1gJIkJcgRH2ezg=";
      };
    };

    fbneo = pkgs.stdenvNoCC.mkDerivation {
      name = "emulation-metadata-fbneo";

      phases = ["installPhase"];

      installPhase = ''
        mkdir -p $out/share/emulation-metadata/fbneo
        cp -r $src/dats/* $out/share/emulation-metadata/fbneo
      '';

      src = pkgs.fetchFromGitHub {
        owner = "libretro";
        repo = "FBNeo";
        rev = "27f594be691e7a7fbb9db9d4a5d0dc12219e4fa4";
        hash = "sha256-BjsEghQvaGyA+zjt7mWv8L6UBvIlW1GDgApEwdKiD2o=";
      };
    };
  };

  systems = pkgs.stdenvNoCC.mkDerivation {
    name = "emulation-metadata";
    buildInputs = with pkgs; [duckdb];
    phases = ["installPhase"];
    installPhase = ''
      mkdir -p $out/share/emulation-metadata
      duckdb -csv <<SQL > $out/share/emulation-metadata/systems.csv
        CREATE MACRO system_key (name) AS (trim(regexp_replace(lower(regexp_replace (strip_accents (name), '[(\[].*?[)\]]', '''''', 'g')), '[^a-z0-9]+', '''''', 'g')));

        CREATE TABLE launchbox_games AS FROM read_csv("${metadata.launchbox}/share/emulation-metadata/launchbox/games.csv");
        CREATE TABLE launchbox_systems AS FROM read_csv("${metadata.launchbox}/share/emulation-metadata/launchbox/systems.csv");
        CREATE TABLE launchbox_system_aliases AS FROM read_csv("${metadata.launchbox}/share/emulation-metadata/launchbox/system_aliases.csv");
        CREATE TABLE esde_systems AS FROM read_csv("${metadata.es-de}/share/emulation-metadata/es-de/systems.csv");

        CREATE TABLE launchbox_systems_aliased
        AS SELECT
            launchbox_systems.*,
            launchbox_system_aliases.Alternate as Name
        FROM launchbox_systems
        JOIN launchbox_system_aliases
        ON launchbox_system_aliases.Name == launchbox_systems.Name;

        SELECT DISTINCT ON(esde_systems.name)
            esde_systems.name as id,
            ifnull(launchbox_systems_aliased.Name, esde_systems.fullName) as name,
            esde_systems.extension as extensions,
            launchbox_systems_aliased.Notes as description
        FROM esde_systems
        LEFT JOIN launchbox_systems_aliased
        ON system_key(esde_systems.fullname) == system_key(launchbox_systems_aliased.Name)
        OR system_key(esde_systems.name) == system_key(launchbox_systems_aliased.Name)
        OR system_key(launchbox_systems_aliased.Name) LIKE '%' || system_key(esde_systems.name) || '%'
        ORDER BY esde_systems.name;
      SQL
    '';
  };

  pegasus-metadata = pkgs.stdenvNoCC.mkDerivation {
    name = "pegasus-metadata";
    phases = ["installPhase"];
    buildInputs = with pkgs; [csvkit];
    installPhase = ''
      mkdir -p $out/share/emulation-metadata/pegasus/


      while IFS=$'\n' read -r line; do
          mkdir -p $out/share/emulation-metadata/pegasus/$key/
          echo "name: $name" >> $out/share/emulation-metadata/pegasus/$key/metadata.txt
          echo "extensions: $(echo $extnames | sed 's/\.//g')" >> $out/share/emulation-metadata/pegasus/$key/metadata.txt
          echo "description: $description" >> $out/share/emulation-metadata/pegasus/$key/metadata.txt
      done <<<$(${systems}/share/emulation-metadata/systems.csv)
    '';
  };
in {
  home.packages = [
    (pkgs.symlinkJoin
      {
        name = "emulation-filesystem-tree";
        paths = [
          # pegasus-metadata
          metadata.es-de
          metadata.launchbox
          metadata.libretro
          metadata.fbneo
          systems
          # retool
          # launchbox-metadata
          # libretro-db_tool
          # libretro-metadata
          #
          # meta-es-de-systems
        ];
      })
  ];

  # launchbox
}
