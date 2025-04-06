import { serveDir } from "@std/http";

export async function respond(req: Request, dir = "static"): Promise<Response> {
  const res = await serveDir(req, {
    fsRoot: dir,
    enableCors: true,
  });

  res.headers.set("Cross-Origin-Opener-Policy", "same-origin");
  res.headers.set("Cross-Origin-Embedder-Policy", " require-corp");

  return res;
}

export default {
  fetch: async (req: Request): Promise<Response> => {
    return await respond(req);
  },
} satisfies Deno.ServeDefaultExport;
