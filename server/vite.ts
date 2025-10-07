import { Express } from "express";import express, { type Express } from "express";

import { Server } from "http";import fs from "fs";

import express from "express";import path from "path";

import { createServer as createViteServer, createLogger } from "vite";

// Simple log function for backend-only deploymentimport { type Server } from "http";

export function log(message: string) {import viteConfig from "../vite.config";

  console.log(`[express] ${message}`);import { nanoid } from "nanoid";

}

const viteLogger = createLogger();

// Backend-only deployment doesn't need Vite

export async function setupVite(app: Express, server: Server) {export function log(message: string, source = "express") {

  console.log("Vite setup skipped - backend-only deployment");  const formattedTime = new Date().toLocaleTimeString("en-US", {

}    hour: "numeric",

    minute: "2-digit",

// Backend-only deployment doesn't serve static files    second: "2-digit",

export function serveStatic(app: Express) {    hour12: true,

  console.log("Static file serving skipped - backend-only deployment");  });

  

  // Just serve a simple message for the root route  console.log(`${formattedTime} [${source}] ${message}`);

  app.get("/", (req, res) => {}

    res.json({ 

      message: "AutoMentor Backend API", export async function setupVite(app: Express, server: Server) {

      status: "running",  const serverOptions = {

      timestamp: new Date().toISOString()    middlewareMode: true,

    });    hmr: { server },

  });    allowedHosts: true as const,

}  };

  const vite = await createViteServer({
    ...viteConfig,
    configFile: false,
    customLogger: {
      ...viteLogger,
      error: (msg, options) => {
        viteLogger.error(msg, options);
        process.exit(1);
      },
    },
    server: serverOptions,
    appType: "custom",
  });

  app.use(vite.middlewares);
  app.use("*", async (req, res, next) => {
    const url = req.originalUrl;

    try {
      const clientTemplate = path.resolve(
        import.meta.dirname,
        "..",
        "client",
        "index.html",
      );

      // always reload the index.html file from disk incase it changes
      let template = await fs.promises.readFile(clientTemplate, "utf-8");
      template = template.replace(
        `src="/src/main.tsx"`,
        `src="/src/main.tsx?v=${nanoid()}"`,
      );
      const page = await vite.transformIndexHtml(url, template);
      res.status(200).set({ "Content-Type": "text/html" }).end(page);
    } catch (e) {
      vite.ssrFixStacktrace(e as Error);
      next(e);
    }
  });
}

export function serveStatic(app: Express) {
  const distPath = path.resolve(import.meta.dirname, "..", "dist", "public");

  if (!fs.existsSync(distPath)) {
    console.error(`Frontend build directory not found: ${distPath}`);
    console.error('Please run: npm run build');
    throw new Error(
      `Could not find the frontend build directory: ${distPath}, make sure to build the client first`,
    );
  }

  console.log(`✅ Serving frontend from: ${distPath}`);
  app.use(express.static(distPath));

  // fall through to index.html if the file doesn't exist
  app.use("*", (_req, res) => {
    const indexPath = path.resolve(distPath, "index.html");
    res.sendFile(indexPath, (err) => {
      if (err) {
        console.error('Error sending index.html:', err);
        res.status(500).send('Internal Server Error');
      }
    });
  });
}
