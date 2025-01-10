import { spawn } from "child_process";
import { stat, readdir } from "fs/promises";
import { resolve } from "path";

const ROOT = resolve(process.argv[2] || ".");
const PORT = process.argv[3] || 3000;

Bun.serve({
  port: PORT,
  async fetch(req) {
    const url = new URL(req.url);
    const pathname = url.pathname.slice(1);
    const scriptPath = resolve(ROOT, pathname);

    if (!scriptPath.startsWith(ROOT)) {
      return new Response("Forbidden", { status: 403 });
    }

    const fileStats = await stat(scriptPath);
    if (!fileStats.isFile()) {
      return new Response("Not Found", { status: 404 });
    }

    const params = Object.fromEntries(url.searchParams.entries());

    return new Promise((resolve) => {
      const script = spawn(scriptPath, {
        stdio: ["ignore", "pipe", "pipe"],
        env: { ...process.env, ...params },
      });

      let stdout = "";
      let stderr = "";

      script.stdout.on("data", (data) => {
        stdout += data;
      });

      script.stderr.on("data", (data) => {
        stderr += data;
      });

      script.on("close", (code) => {
        if (code === 0) {
          resolve(new Response(stdout, { status: 200 }));
        } else {
          resolve(new Response(stderr || "Script error", { status: 500 }));
        }
      });
    });
  },
});

async function listEndpoints(root) {
  const entries = await readdir(root, { withFileTypes: true });
  const endpoints = [];

  for (const entry of entries) {
    if (entry.isFile()) {
      endpoints.push(`/${entry.name}`);
    } else if (entry.isDirectory()) {
      const subEndpoints = await listEndpoints(resolve(root, entry.name));
      endpoints.push(...subEndpoints.map((sub) => `/${entry.name}${sub}`));
    }
  }

  return endpoints;
}

const endpoints = await listEndpoints(ROOT);
console.log(`Server running at http://localhost:${PORT}`);
console.log("Available endpoints:");
for (const endpoint of endpoints) {
  console.log(`  ${endpoint}`);
}
