import { assertEquals, assertStringIncludes } from "@std/assert";
import { join } from "@std/path";
import { respond } from "./server.ts";

async function populateTempDir(
  files: readonly { name: string; content: string }[]
): Promise<string> {
  const encoder = new TextEncoder();
  const tempDirPath = await Deno.makeTempDir();

  const promises = files.map(async ({ name, content }) => {
    await Deno.writeFile(join(tempDirPath, name), encoder.encode(content));
  });

  await Promise.all(promises);

  return tempDirPath;
}

Deno.test(
  "serveDir should return the correct response for an html file",
  async () => {
    const tempDirPath = await populateTempDir([
      { name: "index.html", content: "" },
      { name: "index.pck", content: "" },
      { name: "index.wasm", content: "" },
    ]);

    const req = new Request("http://localhost");
    const res = await respond(req, tempDirPath);
    await res.body?.cancel();

    assertEquals(res.status, 200);
    assertStringIncludes(res.headers.get("Content-Type") ?? "", "text/html");
  }
);

Deno.test(
  "serveDir should return the correct response for a wasm file",
  async () => {
    const tempDirPath = await populateTempDir([
      { name: "index.wasm", content: "" },
    ]);

    const req = new Request("http://localhost/index.wasm");
    const res = await respond(req, tempDirPath);
    await res.body?.cancel();

    assertEquals(res.status, 200);
    assertStringIncludes(
      res.headers.get("Content-Type") ?? "",
      "application/wasm"
    );
  }
);
