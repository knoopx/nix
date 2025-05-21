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
    outputHash = "sha256-VrMoI+3lN+6KxHC5JdWpx45zCbqUowJYk+vwI4JD/S0=";

    buildPhase = ''
      ${lib.getExe pkgs.bun} add rehype-autolink-headings rehype-document rehype-format rehype-highlight rehype-raw rehype-slug rehype-stringify remark-definition-list remark-frontmatter remark-gfm remark-mdx remark-oembed remark-parse remark-rehype remark-wiki-link unified
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
