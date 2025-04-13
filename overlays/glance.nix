final: prev: {
  glance = prev.glance.overrideAttrs (before: {
    preConfigure = ''
      ${prev.lib.getExe prev.ast-grep} run -U -l js internal/glance/static/js/main.js \
      -p 'function setupCollapsibleLists() { $$$ }' \
      --rewrite 'function setupCollapsibleLists() {
        const collapsibleLists = document.querySelectorAll(".list.collapsible-container");
        for (let i = 0; i < collapsibleLists.length; i++) {
          const list = collapsibleLists[i];

          if (list.dataset.collapseAfter === undefined) {
            continue;
          }

          const maxHeight = 400;
          list.style.maxHeight = `''${maxHeight}px`;
          list.style.overflowY = "auto";
          list.style.position = "relative";
        }
      }'

      echo 'let t; document.addEventListener("visibilitychange", () => { clearTimeout(t); if (document.visibilityState === "hidden") t = setTimeout(() => location.reload(), 300000); });' >> internal/glance/static/js/main.js
    '';
  });
}
