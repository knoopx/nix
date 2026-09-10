final: prev: {
  ffmpegthumbnailer = prev.ffmpegthumbnailer.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      # strip the -f (filmstrip overlay) flag — it renders ugly horizontal
      # video-frame stripes across the thumbnail
      substituteInPlace $out/share/thumbnailers/ffmpegthumbnailer.thumbnailer \
        --replace-fail ' -s %s -f' ' -s %s'
    '';
  });
}
