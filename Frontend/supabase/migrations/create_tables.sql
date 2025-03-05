-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create profiles table to sql
CREATE TABLE profiles (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    first_name TEXT,
    last_name TEXT,
    phone_number TEXT,
    province TEXT,
    district TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create function to handle updated_at
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for handling updated_at
CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW
    EXECUTE FUNCTION handle_updated_at();

-- Enable Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create policies
-- Allow users to view their own profile
CREATE POLICY "Users can view own profile"
    ON profiles
    FOR SELECT
    USING (auth.uid() = id);

-- Allow users to insert their own profile
CREATE POLICY "Users can insert own profile"
    ON profiles
    FOR INSERT
    WITH CHECK (auth.uid() = id);

-- Allow users to update their own profile
CREATE POLICY "Users can update own profile"
    ON profiles
    FOR UPDATE
    USING (auth.uid() = id);

-- Create location_data table
CREATE TABLE location_data (
    id SERIAL PRIMARY KEY,
    province TEXT NOT NULL,
    district TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(province, district)
);

-- Create user_activity_logs table
CREATE TABLE user_activity_logs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    activity_type TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS for user_activity_logs
ALTER TABLE user_activity_logs ENABLE ROW LEVEL SECURITY;

-- Create policy for user_activity_logs
CREATE POLICY "Users can view own activity logs"
    ON user_activity_logs
    FOR SELECT
    USING (auth.uid() = user_id);

-- Create stored procedure for user registration
CREATE OR REPLACE PROCEDURE register_user(
    user_id UUID,
    user_email TEXT,
    first_name TEXT,
    last_name TEXT,
    phone_number TEXT,
    province TEXT,
    district TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insert into profiles
    INSERT INTO profiles (
        id,
        email,
        first_name,
        last_name,
        phone_number,
        province,
        district
    ) VALUES (
        user_id,
        user_email,
        first_name,
        last_name,
        phone_number,
        province,
        district
    );

    -- Log the registration
    INSERT INTO user_activity_logs (
        user_id,
        activity_type,
        description
    ) VALUES (
        user_id,
        'REGISTRATION',
        'User completed registration'
    );
END;
$$;

-- Insert initial location data
INSERT INTO location_data (province, district) VALUES
    ('Province 1', 'District 1'),
    ('Province 1', 'District 2'),
    ('Province 2', 'District 3'),
    ('Province 2', 'District 4')
ON CONFLICT (province, district) DO NOTHING;

-- Create function to get districts by province
CREATE OR REPLACE FUNCTION get_districts_by_province(p_province TEXT)
RETURNS TABLE (district TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT ld.district
    FROM location_data ld
    WHERE ld.province = p_province
    ORDER BY ld.district;
END;
$$ LANGUAGE plpgsql; 