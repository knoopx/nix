final: prev: {
  balatro = prev.balatro.overrideAttrs (src: {
    src = prev.requireFile {
      name = "Balatro.exe";
      url = "https://store.steampowered.com/app/2379780/Balatro/";
      hash = "sha256-DXX+FkrM8zEnNNSzesmHiN0V8Ljk+buLf5DE5Z3pP0c=";
    };
  });
}
