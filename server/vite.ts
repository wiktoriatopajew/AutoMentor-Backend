import { Express } from "express";
import { Server } from "http";

export function log(message: string) {
  console.log([express] );
}

export async function setupVite(app: Express, server: Server) {
  console.log("Vite setup skipped - backend-only deployment");
}

export function serveStatic(app: Express) {
  console.log("Static file serving skipped - backend-only deployment");
  
  app.get("/", (req, res) => {
    res.json({ 
      message: "AutoMentor Backend API", 
      status: "running",
      timestamp: new Date().toISOString()
    });
  });
}
