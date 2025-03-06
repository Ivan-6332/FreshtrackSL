import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const supabaseUrl = process.env.SUPABASE_URL as string;
const supabaseKey = process.env.SUPABASE_KEY as string;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_KEY as string;

// Client with anonymous key for public operations
export const supabase = createClient(supabaseUrl, supabaseKey);

// Client with service key for admin operations
export const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey);

if (!supabaseUrl || !supabaseKey) {
  console.error('Missing Supabase credentials');
  process.exit(1);
}