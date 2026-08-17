final: prev:
{
  pi-coding-agent = prev.pi-coding-agent.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        echo "applying pi patches..."
        nm="$out/lib/node_modules/pi-monorepo"

        # Nix highlighting: patches dist/modes/interactive/theme/theme.js
        cat << 'NIX_HIGHLIGHTING_PATCH' | patch -p1 -f --directory="$nm"
--- a/dist/modes/interactive/theme/theme.js
+++ b/dist/modes/interactive/theme/theme.js
@@ -946,6 +946,17 @@
     if (!ext)
         return undefined;
     const extToLang = {
+        astro: "astro",
+        diff: "diff",
+        hujson: "json",
+        jsonc: "json",
+        jsonl: "json",
+        justfile: "makefile",
+        mdx: "markdown",
+        mts: "typescript",
+        nix: "nix",
+        nu: "nu",
+        zig: "zig",
         ts: "typescript",
         tsx: "typescript",
         js: "javascript",
NIX_HIGHLIGHTING_PATCH

        # Markdown code-block: patches node_modules/@earendil-works/pi-tui/dist/components/markdown.js
        cat << 'MARKDOWN_CODE_BLOCK_PATCH' | patch -p1 -f --directory="$nm/node_modules/@earendil-works/pi-tui"
--- a/dist/components/markdown.js
+++ b/dist/components/markdown.js
@@ -200,13 +200,15 @@
         trimPartialClosingFences(tokens);
         // Convert tokens to styled terminal output
         const renderedLines = [];
+        let prevTokenType;
         for (let i = 0; i < tokens.length; i++) {
             const token = tokens[i];
             const nextToken = tokens[i + 1];
-            const tokenLines = this.renderToken(token, contentWidth, nextToken?.type);
+            const tokenLines = this.renderToken(token, contentWidth, nextToken?.type, undefined, prevTokenType);
             for (const tokenLine of tokenLines) {
                 renderedLines.push(tokenLine);
             }
+            prevTokenType = token.type;
         }
         // Wrap lines (NO padding, NO background yet)
         const wrappedLines = [];
@@ -326,7 +328,43 @@
             stylePrefix: this.getDefaultStylePrefix(),
         };
     }
-    renderToken(token, width, nextTokenType, styleContext) {
+    /**
+     * Render a code block as an indented block with a tinted background.
+     */
+    renderCodeBlock(code, lang, availableWidth) {
+        const lines = [];
+        const codeBlockStyle = this.theme.codeBlock;
+        const indent = "  ";
+        const codeWidth = Math.max(1, availableWidth - indent.length);
+        const width = Math.max(0, availableWidth);
+        const fallbackPadding = codeBlockStyle(" ".repeat(width));
+        const topPadding = this.theme.codeBlockPaddingTop
+            ? this.theme.codeBlockPaddingTop("▀".repeat(width))
+            : fallbackPadding;
+        const bottomPadding = this.theme.codeBlockPaddingBottom
+            ? this.theme.codeBlockPaddingBottom("▄".repeat(width))
+            : fallbackPadding;
+        let codeLines;
+        if (this.theme.highlightCode) {
+            codeLines = this.theme.highlightCode(code, lang);
+        }
+        else {
+            codeLines = code.split("\n");
+        }
+        lines.push(topPadding);
+        for (const codeLine of codeLines) {
+            const wrappedLines = wrapTextWithAnsi(codeLine, codeWidth);
+            for (const wrappedLine of wrappedLines) {
+                const visibleLen = visibleWidth(wrappedLine);
+                const padding = " ".repeat(Math.max(0, availableWidth - indent.length - visibleLen));
+                const content = indent + wrappedLine + padding;
+                lines.push(codeBlockStyle(content));
+            }
+        }
+        lines.push(bottomPadding);
+        return lines;
+    }
+    renderToken(token, width, nextTokenType, styleContext, prevTokenType) {
         const lines = [];
         switch (token.type) {
             case "heading": {
@@ -380,25 +418,8 @@
                 break;
             }
             case "code": {
-                const indent = this.theme.codeBlockIndent ?? "  ";
-                lines.push(this.theme.codeBlockBorder(`\`\`\`''${token.lang || ""}`));
-                if (this.theme.highlightCode) {
-                    const highlightedLines = this.theme.highlightCode(token.text, token.lang);
-                    for (const hlLine of highlightedLines) {
-                        lines.push(`''${indent}''${hlLine}`);
-                    }
-                }
-                else {
-                    // Split code by newlines and style each line
-                    const codeLines = token.text.split("\n");
-                    for (const codeLine of codeLines) {
-                        lines.push(`''${indent}''${this.theme.codeBlock(codeLine)}`);
-                    }
-                }
-                lines.push(this.theme.codeBlockBorder("```"));
-                if (nextTokenType && nextTokenType !== "space") {
-                    lines.push(""); // Add spacing after code blocks (unless space token follows)
-                }
+                const codeBlockLines = this.renderCodeBlock(token.text, token.lang, width);
+                lines.push(...codeBlockLines);
                 break;
             }
             case "list": {
                 const listLines = this.renderList(token, 0, width, styleContext);
@@ -468,7 +489,11 @@
                 }
                 break;
             case "space":
-                // Space tokens represent blank lines in markdown
+                // Space tokens represent blank lines in markdown.
+                // Skip spacing directly around code blocks; the block supplies its own padding.
+                if (prevTokenType === "code" || nextTokenType === "code") {
+                    break;
+                }
                 lines.push("");
                 break;
             default:
MARKDOWN_CODE_BLOCK_PATCH

        # Tool output auto-expand: patches settings-manager.js and interactive-mode.js
        # Adds "toolOutputExpanded" setting to ~/.pi/agent/settings.json
        cat << 'TOOL_OUTPUT_EXPAND_PATCH' | patch -p1 -f --directory="$nm"
--- a/dist/core/settings-manager.js
+++ b/dist/core/settings-manager.js
@@ -578,6 +578,9 @@
     getHideThinkingBlock() {
         return this.settings.hideThinkingBlock ?? false;
     }
+    getToolOutputExpanded() {
+        return this.settings.toolOutputExpanded ?? false;
+    }
     getShowCacheMissNotices() {
         return this.settings.showCacheMissNotices ?? false;
     }
--- a/dist/modes/interactive/interactive-mode.js
+++ b/dist/modes/interactive/interactive-mode.js
@@ -373,5 +373,6 @@
         // Load hide thinking block setting
         this.hideThinkingBlock = this.settingsManager.getHideThinkingBlock();
+        this.toolOutputExpanded = this.settingsManager.getToolOutputExpanded();
         this.outputPad = this.settingsManager.getOutputPad();
         // Register themes from resource loader and initialize
         setRegisteredThemes(this.session.resourceLoader.getThemes().themes);
@@ -1462,5 +1463,6 @@
         this.footerDataProvider.setCwd(this.sessionManager.getCwd());
         this.hideThinkingBlock = this.settingsManager.getHideThinkingBlock();
+        this.toolOutputExpanded = this.settingsManager.getToolOutputExpanded();
         this.outputPad = this.settingsManager.getOutputPad();
         this.ui.setShowHardwareCursor(this.settingsManager.getShowHardwareCursor());
         const clearOnShrink = this.settingsManager.getClearOnShrink();
@@ -4780,5 +4782,6 @@
             }
             this.hideThinkingBlock = this.settingsManager.getHideThinkingBlock();
+            this.toolOutputExpanded = this.settingsManager.getToolOutputExpanded();
             this.outputPad = this.settingsManager.getOutputPad();
             this.rebuildChatFromMessages();
             chatRestoredBeforeSessionStart = true;
TOOL_OUTPUT_EXPAND_PATCH
      '';
  });
}
