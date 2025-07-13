final: prev: {
  calf = prev.calf.overrideAttrs (old: {
    buildInputs = with prev; [
      cairo
      expat
      fftwSinglePrec
      fluidsynth
      glib
      gtk2
      libjack2
      ladspaH
      lv2
    ];
  });
}
