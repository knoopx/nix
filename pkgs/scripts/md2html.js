#!/usr/bin/env node

import { unified } from "unified";
import rehypeHighlight from "rehype-highlight";
import rehypeDocument from "rehype-document";
import remarkRehype from "remark-rehype";
import remarkGfm from "remark-gfm";
import remarkWikiLink from "remark-wiki-link";
import rehypeStringify from "rehype-stringify";
import remarkParse from "remark-parse";
import remarkFrontmatter from "remark-frontmatter";
import rehypeAutolinkHeadings from "rehype-autolink-headings";
import rehypeSlug from "rehype-slug";

import { visit } from "unist-util-visit";

function remarkDefinitionList() {
  return (tree) => {
    visit(tree, "paragraph", (node, index, parent) => {
      const definitions = [];
      let currentTerm = [];
      let currentDef = [];
      let isDefinitionList = false;

      // Process each line while preserving node structure
      let currentLine = [];
      node.children.forEach((child) => {
        if (child.type === "text") {
          const lines = child.value.split("\n");
          lines.forEach((line, i) => {
            const match = line.match(/^(.+?):: (.*)$/);
            if (match) {
              isDefinitionList = true;
              if (currentTerm.length > 0) {
                definitions.push({
                  term: currentTerm,
                  definition: currentDef
                });
              }
              currentTerm = [{ type: "text", value: match[1].trim() }];
              currentDef = [{ type: "text", value: match[2].trim() }];
            } else if (currentTerm.length > 0 && line.trim()) {
              currentDef.push({ type: "text", value: line.trim() + " " });
            }
          });
        } else {
          if (currentDef.length > 0) {
            currentDef.push(child);
          }
        }
      });

      if (currentTerm.length > 0) {
        definitions.push({
          term: currentTerm,
          definition: currentDef
        });
      }

      if (isDefinitionList) {
        parent.children[index] = {
          type: "dl",
          children: definitions.flatMap(({ term, definition }) => [
            {
              type: "dt",
              children: term,
              data: { hName: "dt" }
            },
            {
              type: "dd",
              children: definition,
              data: { hName: "dd" }
            }
          ]),
          data: { hName: "dl" }
        };
      }
    });
  };
}

async function processMarkdown(input) {
  const file = await unified()
    .use(remarkParse)
    .use(remarkDefinitionList)
    .use(remarkGfm)
    .use(remarkFrontmatter, ["yaml", "toml"])
    .use(remarkWikiLink, {
      pageResolver: (pageName) => [pageName],
      hrefTemplate: (permalink) => `note://${permalink}`,
    })
    .use(remarkRehype, {
      handlers: {},
    })
    .use(rehypeSlug)
    .use(rehypeAutolinkHeadings)
    .use(rehypeHighlight)
    .use(rehypeDocument, {
      css: "@@CSS@@",
    })
    .use(rehypeStringify)
    .process(input);
  console.log(String(file));
}

// Read from stdin
let inputData = "";

process.stdin.setEncoding("utf8");
process.stdin.on("data", (chunk) => {
  inputData += chunk;
});

process.stdin.on("end", () => {
  processMarkdown(inputData).catch((err) => {
    console.error(`Error: ${err.message}`);
    process.exit(1);
  });
});
