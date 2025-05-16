{
  pkgs,
  lib,
  ...
}: let
  deps = pkgs.stdenvNoCC.mkDerivation {
    name = "md2html-deps";
    dontUnpack = true;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-jDsX7s/d37KC7n9yUUvb3QaW2TVbIZRvwZ0CkZrWMxc=";

    buildPhase = ''
      ${lib.getExe pkgs.bun} add unified remark-mdx rehype-highlight rehype-autolink-headings rehype-slug rehype-document remark-frontmatter remark-parse remark-rehype remark-wiki-link rehype-stringify remark-definition-list remark-gfm
      mv node_modules $out
    '';
  };
in
  pkgs.stdenvNoCC.mkDerivation {
    name = "md2html";
    dontUnpack = true;
    src = ./scripts/md2html.js;
    buildPhase = ''
      install -D -m755 $src $out/bin/md2html
      substituteInPlace $out/bin/md2html --replace-fail "@@CSS@@" "${./scripts/md2html.css}"
      cp -r ${deps} $out/bin/node_modules
    '';
  }
