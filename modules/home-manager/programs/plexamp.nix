{ pkgs, ... }: {
  home.activation.plexampSettings =
    let
      setScript = pkgs.writeText "plexamp-set-settings.py" ''
        import plyvel, sys

        dbpath = sys.argv[1]

        settings = {
            "activeTab": b"SDiscover",
            "alwaysOnTop": b"Btrue",
            "audioDeviceUuid": b"Sdefault",
            "autoPlayEnabled": b"Bfalse",
            "chartTimespan": b"Smonth",
            "keymap": b'{"prev":null,"next":null,"stop":null,"playPause":null,"volumeUp":"Command+Alt+Up","volumeDown":"Command+Alt+Down","skipForward":null,"skipBack":null,"activateHome":null,"activateLibrary":null,"activateSearch":"Control+F","activateDownloads":null,"activateSettings":null,"activatePlayer":null,"skipToNextAlbum":null,"activate":null}',
            "openAiApiKey": b"Sany",
            "playQueueTabIndex": b"N1",
            "premium": b"Btrue",
            "sampleRateMatching": b"N0",
            "sendNotifications": b"Bfalse",
            "showFullScreenPlayerOnStart": b"Bfalse",
            "sonicSageUseGpt4": b"Btrue",
            "useDalle3": b"Bfalse",
        }

        try:
            db = plyvel.DB(dbpath)
        except Exception as e:
            print("plexamp: leveldb locked (plexamp running?): %s; not applied" % e)
            sys.exit(0)

        for name, body in settings.items():
            fullkey = b"_file://\x00\x01@Plexamp:settings:" + name.encode()
            db.put(fullkey, b"\x01" + body)
        db.close()
        print("plexamp: wrote %d settings" % len(settings))
      '';
    in
    ''
      db="$HOME/.config/Plexamp/Local Storage/leveldb"
      if [ ! -d "$db" ]; then
        echo "plexamp: no leveldb at $db; skipping" >&2
        exit 0
      fi
      PYTHONPATH="${pkgs.python313Packages.plyvel}/lib/python3.13/site-packages" \
        "${pkgs.python313}/bin/python3" ${setScript} "$db"
    '';

}
