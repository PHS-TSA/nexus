import { serveDir, serveFile } from "@std/http";
import { join } from "@std/path";

export async function respond(req: Request, dir = "static"): Promise<Response> {
  const res = await serveDir(req, {
    fsRoot: dir,
    enableCors: true,
    headers: [
      "Cross-Origin-Opener-Policy:same-origin",
      "Cross-Origin-Embedder-Policy:require-corp",
    ],
  });

  // SPA mode
  if (res.status == 404) {
    return serveFile(req, join(dir, "index.html"));
  }

  return res;
}

export default {
  fetch: async (req: Request): Promise<Response> => {
    return await respond(req);
  },
} satisfies Deno.ServeDefaultExport;
