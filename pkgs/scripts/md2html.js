#!/usr/bin/env node

import { unified } from "unified";
import rehypeHighlight from "rehype-highlight";
import rehypeDocument from "rehype-document";
import remarkRehype from "remark-rehype";
import remarkGfm from "remark-gfm";
import remarkWikiLink from "remark-wiki-link";
import rehypeStringify from "rehype-stringify";
import remarkParse from "remark-parse";
import remarkMdx from "remark-mdx";
import remarkFrontmatter from "remark-frontmatter";
import {
  remarkDefinitionList,
  defListHastHandlers,
} from "remark-definition-list";

import rehypeAutolinkHeadings from "rehype-autolink-headings";
import rehypeSlug from "rehype-slug";

async function processMarkdown(input) {
  const file = await unified()
    .use(remarkParse)
    // .use(remarkMdx)
    .use(remarkGfm)
    .use(remarkFrontmatter, ["yaml", "toml"])
    .use(remarkDefinitionList)
    .use(remarkWikiLink)
    .use(remarkRehype, {
      handlers: {
        ...defListHastHandlers,
      },
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
