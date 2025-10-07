-- Auto-generated PostgreSQL schema for AutoMentor
-- This file will be executed automatically if tables don't exist

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  email TEXT,
  is_admin BOOLEAN DEFAULT FALSE,
  has_subscription BOOLEAN DEFAULT FALSE,
  is_online BOOLEAN DEFAULT FALSE,
  is_blocked BOOLEAN DEFAULT FALSE,
  referral_code TEXT UNIQUE,
  referred_by TEXT,
  last_seen TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Subscriptions table
CREATE TABLE IF NOT EXISTS subscriptions (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id TEXT REFERENCES users(id),
  amount REAL,
  status TEXT DEFAULT 'active',
  purchased_at TIMESTAMP DEFAULT NOW(),
  expires_at TIMESTAMP
);

-- Chat sessions table
CREATE TABLE IF NOT EXISTS chat_sessions (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id TEXT REFERENCES users(id),
  vehicle_info TEXT,
  status TEXT DEFAULT 'active',
  created_at TIMESTAMP DEFAULT NOW(),
  last_activity TIMESTAMP DEFAULT NOW()
);

-- Messages table
CREATE TABLE IF NOT EXISTS messages (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id TEXT REFERENCES chat_sessions(id),
  sender_id TEXT REFERENCES users(id),
  sender_type TEXT,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Attachments table
CREATE TABLE IF NOT EXISTS attachments (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id TEXT REFERENCES messages(id),
  file_name TEXT NOT NULL,
  original_name TEXT NOT NULL,
  file_size INTEGER NOT NULL,
  mime_type TEXT NOT NULL,
  file_path TEXT NOT NULL,
  uploaded_at TIMESTAMP DEFAULT NOW(),
  expires_at TIMESTAMP
);

-- Referral rewards table
CREATE TABLE IF NOT EXISTS referral_rewards (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  referrer_id TEXT REFERENCES users(id),
  referred_id TEXT REFERENCES users(id),
  reward_type TEXT NOT NULL,
  reward_value INTEGER NOT NULL,
  status TEXT DEFAULT 'pending',
  required_referrals INTEGER DEFAULT 3,
  current_referrals INTEGER DEFAULT 0,
  reward_cycle INTEGER DEFAULT 1,
  created_at TIMESTAMP DEFAULT NOW(),
  awarded_at TIMESTAMP
);

-- Google Ads configuration table (changed to TEXT PRIMARY KEY for consistency)
CREATE TABLE IF NOT EXISTS google_ads_config (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  conversion_id TEXT,
  purchase_label TEXT,
  signup_label TEXT,
  enabled BOOLEAN DEFAULT FALSE,
  updated_at TIMESTAMP DEFAULT NOW()
);

-- App configuration table (changed to TEXT PRIMARY KEY for consistency)
CREATE TABLE IF NOT EXISTS app_config (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  stripe_publishable_key TEXT,
  stripe_secret_key TEXT,
  stripe_webhook_secret TEXT,
  paypal_client_id TEXT,
  paypal_client_secret TEXT,
  paypal_webhook_id TEXT,
  paypal_mode TEXT DEFAULT 'sandbox',
  smtp_host TEXT,
  smtp_port INTEGER,
  smtp_secure BOOLEAN DEFAULT TRUE,
  smtp_user TEXT,
  smtp_pass TEXT,
  email_from TEXT,
  email_from_name TEXT DEFAULT 'AutoMentor',
  app_name TEXT DEFAULT 'AutoMentor',
  app_url TEXT DEFAULT 'http://localhost:5000',
  support_email TEXT,
  favicon_path TEXT,
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Analytics events table
CREATE TABLE IF NOT EXISTS analytics_events (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type TEXT NOT NULL,
  event_name TEXT NOT NULL,
  user_id TEXT REFERENCES users(id),
  session_id TEXT,
  properties TEXT,
  page_url TEXT,
  referrer TEXT,
  user_agent TEXT,
  ip_address TEXT,
  country TEXT,
  city TEXT,
  device_type TEXT,
  browser TEXT,
  os TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Daily statistics table (changed to TEXT PRIMARY KEY for consistency)
CREATE TABLE IF NOT EXISTS daily_stats (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  date TEXT NOT NULL UNIQUE,
  total_users INTEGER DEFAULT 0,
  new_users INTEGER DEFAULT 0,
  active_users INTEGER DEFAULT 0,
  total_sessions INTEGER DEFAULT 0,
  total_chats INTEGER DEFAULT 0,
  new_subscriptions INTEGER DEFAULT 0,
  total_revenue REAL DEFAULT 0,
  page_views INTEGER DEFAULT 0,
  bounce_rate REAL DEFAULT 0,
  avg_session_duration INTEGER DEFAULT 0,
  conversion_rate REAL DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Revenue analytics table
CREATE TABLE IF NOT EXISTS revenue_analytics (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id TEXT REFERENCES users(id),
  subscription_id TEXT REFERENCES subscriptions(id),
  amount REAL NOT NULL,
  currency TEXT DEFAULT 'PLN',
  payment_method TEXT,
  subscription_type TEXT,
  is_refund BOOLEAN DEFAULT FALSE,
  refund_amount REAL DEFAULT 0,
  marketing_source TEXT,
  conversion_funnel_step INTEGER,
  customer_lifetime_value REAL DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Content pages table (CMS)
CREATE TABLE IF NOT EXISTS content_pages (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  page_key TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  meta_description TEXT,
  meta_keywords TEXT,
  content TEXT,
  is_published BOOLEAN DEFAULT TRUE,
  seo_title TEXT,
  canonical_url TEXT,
  og_title TEXT,
  og_description TEXT,
  og_image TEXT,
  last_edited_by TEXT,
  version INTEGER DEFAULT 1,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- FAQs table
CREATE TABLE IF NOT EXISTS faqs (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  category TEXT DEFAULT 'general',
  is_published BOOLEAN DEFAULT TRUE,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Testimonials table
CREATE TABLE IF NOT EXISTS testimonials (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT,
  content TEXT NOT NULL,
  rating INTEGER DEFAULT 5,
  is_approved BOOLEAN DEFAULT FALSE,
  is_published BOOLEAN DEFAULT FALSE,
  avatar TEXT,
  company TEXT,
  position TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Media library table
CREATE TABLE IF NOT EXISTS media_library (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  filename TEXT NOT NULL,
  original_name TEXT NOT NULL,
  mime_type TEXT NOT NULL,
  size INTEGER NOT NULL,
  path TEXT NOT NULL,
  alt TEXT,
  title TEXT,
  description TEXT,
  tags TEXT,
  uploaded_by TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_referral_code ON users(referral_code);
CREATE INDEX IF NOT EXISTS idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_chat_sessions_user_id ON chat_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_messages_session_id ON messages(session_id);
CREATE INDEX IF NOT EXISTS idx_messages_sender_id ON messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_attachments_message_id ON attachments(message_id);
CREATE INDEX IF NOT EXISTS idx_referral_rewards_referrer_id ON referral_rewards(referrer_id);
CREATE INDEX IF NOT EXISTS idx_referral_rewards_referred_id ON referral_rewards(referred_id);
CREATE INDEX IF NOT EXISTS idx_analytics_events_user_id ON analytics_events(user_id);
CREATE INDEX IF NOT EXISTS idx_analytics_events_created_at ON analytics_events(created_at);
CREATE INDEX IF NOT EXISTS idx_revenue_analytics_user_id ON revenue_analytics(user_id);
CREATE INDEX IF NOT EXISTS idx_content_pages_page_key ON content_pages(page_key);
CREATE INDEX IF NOT EXISTS idx_faqs_category ON faqs(category);

-- Insert default admin user if no users exist
INSERT INTO users (username, password, email, is_admin)
SELECT 'admin', '$2b$10$dummy.hash.for.admin.user', 'admin@automentor.com', TRUE
WHERE NOT EXISTS (SELECT 1 FROM users WHERE is_admin = TRUE);

COMMIT;