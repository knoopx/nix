#!/usr/bin/env node

const fs = require("fs");
const { remark } = require("remark");

function nodeToPango(node) {
  let pango = "";

  // Handle different node types from the Markdown AST
  switch (node.type) {
    case "root":
      // The root node contains all other nodes. Wrap output in <markup>.
      pango += "<markup>";
      // Process children
      if (node.children) {
        node.children.forEach((child) => {
          pango += nodeToPango(child);
        });
      }
      pango += "</markup>";
      break;

    case "paragraph":
      // Paragraphs don't need specific Pango tags, just process children and add newline
      if (node.children) {
        node.children.forEach((child) => {
          pango += nodeToPango(child);
        });
      }
      pango += "\n"; // Add a newline after a paragraph
      break;

    case "heading":
      // Headings can use size and weight attributes
      const headingSize =
        {
          1: "xx-large", // H1
          2: "x-large", // H2
          3: "large", // H3
          4: "medium", // H4 (default size)
          5: "small", // H5
          6: "x-small", // H6
        }[node.depth] || "medium"; // Default to medium if depth is unexpected

      pango += `<span size="${headingSize}" weight="bold">`;
      if (node.children) {
        node.children.forEach((child) => {
          pango += nodeToPango(child);
        });
      }
      pango += "</span>\n"; // Add newline after heading
      break;

    case "text":
      // Plain text content. Escape special Pango characters.
      pango += escapePango(node.value);
      break;

    case "emphasis":
      // Italic text
      pango += '<span font_style="italic">';
      if (node.children) {
        node.children.forEach((child) => {
          pango += nodeToPango(child);
        });
      }
      pango += "</span>";
      break;

    case "strong":
      // Bold text
      pango += '<span weight="bold">';
      if (node.children) {
        node.children.forEach((child) => {
          pango += nodeToPango(child);
        });
      }
      pango += "</span>";
      break;

    case "list":
      // Lists. Pango doesn't have native list items.
      // We'll handle prefixes in listItem.
      if (node.children) {
        node.children.forEach((child) => {
          pango += nodeToPango(child);
        });
      }
      // Add an extra newline after the list for separation
      pango += "\n";
      break;

    case "listItem":
      // List items. Add a prefix based on list type (ordered/unordered).
      const prefix = node.ordered ? `${node.position.start.line}. ` : "• ";
      pango += prefix;
      if (node.children) {
        node.children.forEach((child) => {
          // Process children, typically a paragraph containing the list item text
          pango += nodeToPango(child);
        });
      }
      pango += "\n"; // Newline after each list item
      break;

    case "code":
      // Code block or inline code. Pango can use monospace font and background.
      // This simplistic conversion treats both as monospace.
      // For block code, you might want to add a background or border.
      pango += '<span font_family="monospace">';
      pango += escapePango(node.value); // Escape code content
      pango += "</span>";
      // Add newline after code block (assuming it's a block, adjust if handling inline differently)
      if (node.lang || node.meta) {
        // Simple check if it looks like a block
        pango += "\n";
      }
      break;

    case "link":
      // Links. Pango can use href attribute and underline.
      pango += `<a href="${escapePango(node.url)}" underline="single">`;
      if (node.children) {
        node.children.forEach((child) => {
          pango += nodeToPango(child);
        });
      }
      pango += "</a>";
      break;

    case "blockquote":
      // Blockquotes. Pango doesn't have a direct tag. Use indentation.
      // This adds indentation to each line within the blockquote.
      // A more robust solution might process line by line.
      pango += '<span left_margin="2em">'; // Add left margin for indentation
      if (node.children) {
        node.children.forEach((child) => {
          pango += nodeToPango(child);
        });
      }
      pango += "</span>\n";
      break;

    case "thematicBreak":
      // Horizontal rule. Represent with dashes.
      pango += "--------------------\n";
      break;

    case "html":
      // Basic handling for raw HTML. Pango doesn't render HTML.
      // We'll just output the HTML content as text, escaped.
      pango += escapePango(node.value);
      break;

    case "definition":
    case "footnoteDefinition":
    case "footnoteReference":
    case "image":
    case "imageReference":
    case "inlineCode": // Remark often uses 'code' for both. Handle if needed separately.
    case "linkReference":
    case "yaml": // Frontmatter
    case "toml": // Frontmatter
    case "csv": // Frontmatter
    case "table": // Tables are complex, skipping for this basic example
    case "tableRow":
    case "tableCell":
    case "break": // Hard break
      // Add more cases here for other Markdown elements you want to support.
      // For now, just ignore or add a placeholder.
      // console.warn(`[WARN] Unsupported node type: ${node.type}`);
      break;

    default:
      // For any other node type, just process its children if it has any.
      if (node.children) {
        node.children.forEach((child) => {
          pango += nodeToPango(child);
        });
      }
      break;
  }

  return pango;
}

function escapePango(text) {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/'/g, "&apos;")
    .replace(/"/g, "&quot;");
}

const args = process.argv.slice(2);
let inputSource = process.stdin;
let outputSource = process.stdout;
let inputFilename = null;

if (args.length > 0) {
  inputFilename = args[0];
  inputSource = fs.createReadStream(inputFilename);
}

let markdownInput = "";

inputSource.on("data", (chunk) => {
  markdownInput += chunk;
});

inputSource.on("end", () => {
  try {
    const tree = remark().parse(markdownInput);
    outputSource.write(nodeToPango(tree));
  } catch (error) {
    console.error(`Error processing Markdown: ${error.message}`);
    process.exit(1);
  }
});

inputSource.on("error", (error) => {
  console.error(`Error reading input: ${error.message}`);
  process.exit(1);
});
