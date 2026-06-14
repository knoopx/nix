{pkgs, lib}: _colorScheme: let
  palette = _colorScheme.palette;

  c = name: "#${palette.${name}}";

  css = pkgs.writeText "render-markdown.css" ''
    /* Auto-generated from defaults.colorScheme.palette */
    :root {
      --bg: ${c "base00"};
      --bg-alt: ${c "base01"};
      --border: ${c "base02"};
      --muted: ${c "base03"};
      --text-dim: ${c "base04"};
      --text: ${c "base05"};
      --text-light: ${c "base06"};
      --accent: ${c "base07"};
      --red: ${c "base08"};
      --orange: ${c "base09"};
      --yellow: ${c "base0A"};
      --green: ${c "base0B"};
      --cyan: ${c "base0C"};
      --blue: ${c "base0D"};
      --purple: ${c "base0E"};
      --magenta: ${c "base0F"};
    }
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
    html{background:var(--bg);color:var(--text)}
    body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen,Ubuntu,sans-serif;font-size:16px;line-height:1.7;color:var(--text);background:var(--bg);margin:0;padding:2rem 4rem}
    h1,h2,h3,h4,h5,h6{color:var(--accent);line-height:1.3;margin:1.8em 0 0.6em}
    h1:first-child{margin-top:0}
    h1{font-size:2em;border-bottom:1px solid var(--border);padding-bottom:0.3em}
    h2{font-size:1.5em;border-bottom:1px solid var(--border);padding-bottom:0.25em}
    h3{font-size:1.25em}
    p{margin:0.8em 0}
    a{color:var(--cyan);text-decoration:none}
    a:hover{text-decoration:underline}
    strong{color:var(--text-light)}
    em{color:var(--purple)}
    code{font-family:"JetBrains Mono","Fira Code","Cascadia Code",monospace;font-size:0.9em;background:var(--bg-alt);padding:0.15em 0.35em;border-radius:4px}
    pre{background:var(--bg-alt);border:1px solid var(--border);border-radius:6px;padding:1rem 1.25rem;overflow-x:auto;margin:1em 0}
    pre code{background:none;padding:0}
    blockquote{border-left:3px solid var(--muted);color:var(--text-dim);padding:0.5em 1em;margin:1em 0}
    ul,ol{padding-left:1.5em;margin:0.8em 0}
    li{margin:0.3em 0}
    table{border-collapse:collapse;width:100%;margin:1em 0}
    th,td{border:1px solid var(--border);padding:0.5em 0.75em;text-align:left}
    th{background:var(--bg-alt);color:var(--accent)}
    hr{border:none;border-top:1px solid var(--border);margin:2em 0}
    img{max-width:100%;border-radius:6px}
    mark{background:var(--orange);color:var(--bg);padding:0.1em 0.2em;border-radius:2px}
    code span.al{color:${c "base08"};font-weight:bold}
    code span.an{color:${c "base04"};font-weight:bold;font-style:italic}
    code span.at{color:${c "base0F"}}
    code span.bn{color:${c "base09"}}
    code span.bu{color:${c "base0C"}}
    code span.cf{color:${c "base07"};font-weight:bold}
    code span.ch{color:${c "base0B"}}
    code span.cn{color:${c "base08"}}
    code span.co{color:${c "base04"};font-style:italic}
    code span.cv{color:${c "base04"};font-weight:bold;font-style:italic}
    code span.do{color:${c "base04"};font-style:italic}
    code span.dt{color:${c "base07"}}
    code span.dv{color:${c "base09"}}
    code span.er{color:${c "base08"};font-weight:bold}
    code span.fl{color:${c "base09"}}
    code span.fu{color:${c "base0C"}}
    code span.im{color:${c "base0B"};font-weight:bold}
    code span.in{color:${c "base04"};font-weight:bold;font-style:italic}
    code span.kw{color:${c "base07"};font-weight:bold}
    code span.op{color:${c "base03"}}
    code span.ot{color:${c "base07"}}
    code span.pp{color:${c "base0E"}}
    code span.sc{color:${c "base0C"}}
    code span.ss{color:${c "base0F"}}
    code span.st{color:${c "base0B"}}
    code span.va{color:${c "base05"}}
    code span.vs{color:${c "base0B"}}
    code span.wa{color:${c "base04"};font-weight:bold;font-style:italic}
  '';

  script = pkgs.writeShellApplication {
    name = "markdown-viewer";
    runtimeInputs = [pkgs.pandoc pkgs.xdg-utils];
    text = ''
      if [ $# -lt 1 ] || [ ! -f "$1" ]; then
        echo "Usage: markdown-viewer <markdown-file>" >&2
        exit 1
      fi

      INPUT="$1"
      OUTPUT="/tmp/render-$(basename "''${INPUT%.md}").html"

      pandoc \
        --from=markdown-implicit_figures --to=html --embed-resources --standalone \
        --css=${css} \
        "$INPUT" -o "$OUTPUT"

      xdg-open "file://$OUTPUT"
    '';
  };

  desktopItem = pkgs.makeDesktopItem {
    name = "markdown-viewer";
    desktopName = "Markdown Viewer";
    comment = "Render markdown to styled HTML with pandoc and open in browser";
    exec = "markdown-viewer %f";
    icon = "text-markdown";
    terminal = false;
    type = "Application";
    mimeTypes = ["text/markdown"];
  };
in
  pkgs.runCommand "markdown-viewer-bundle" {
    nativeBuildInputs = [pkgs.makeBinaryWrapper];
  } ''
    mkdir -p $out/bin $out/share/applications
    cp -r ${script}/bin/markdown-viewer $out/bin/markdown-viewer
    install -m 444 ${desktopItem}/share/applications/markdown-viewer.desktop \
      $out/share/applications/markdown-viewer.desktop
    wrapProgram "$out/bin/markdown-viewer" \
      --prefix PATH : "${pkgs.lib.makeBinPath [pkgs.pandoc pkgs.xdg-utils]}"
  ''
