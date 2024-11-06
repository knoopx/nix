{pkgs, ...}: (
  let
    pname = "semantic-grep";
    version = "0.6.0";
  in
    pkgs.buildGoModule {
      inherit pname version;
      vendorHash = "sha256-HpKY5DkP9hRtH9O18irlNE2yd8eTSLogTpYTWR1kbXA=";

      src = pkgs.fetchFromGitHub {
        owner = "arunsupe";
        repo = "semantic-grep";
        rev = "v${version}";
        hash = "sha256-uyPyj7Qk/iCqY/cRg3aJj9+gejDetHZCQtt/4QFxilg=";
      };

      meta = {
        homepage = "https://github.com/arunsupe/semantic-grep";
        description = "grep for words with similar meaning to the query";
      };
    }
)
