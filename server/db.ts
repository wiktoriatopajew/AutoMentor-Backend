import { drizzle as drizzlePg } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from "../shared/schema";

// Database configuration - using PostgreSQL for Railway deployment
let db: any;
let sql: any; // Will be initialized with the postgres client

console.log('Database config check:');
console.log('NODE_ENV:', process.env.NODE_ENV);
console.log('DATABASE_URL exists:', !!process.env.DATABASE_URL);
console.log('DATABASE_URL length:', process.env.DATABASE_URL?.length || 0);

async function initializeDatabase() {
  // Use PostgreSQL (required for Railway deployment)
  const databaseUrl = process.env.DATABASE_URL || 'postgresql://user:pass@localhost:5432/db';
  const client = postgres(databaseUrl);
  sql = client; // Set sql for export
  db = drizzlePg(client, { schema });

  // Migrations are permanently disabled. No migration logic will run.
  console.log('⭐️ PostgreSQL migrations are permanently disabled in db.ts.');

  // Debug: print applied migrations from __drizzle_migrations (if exists)
  try {
    const applied = await client`SELECT id, name, hash, created_at FROM __drizzle_migrations ORDER BY created_at`;
    console.log('Applied migrations rows:', applied);
  } catch (e) {
    console.warn('Could not read __drizzle_migrations table:', String(e));
  }

  console.log('�️ Connected to PostgreSQL database');
}

// Initialize database
const dbReady = initializeDatabase().then(() => db);
export { db, dbReady, sql };