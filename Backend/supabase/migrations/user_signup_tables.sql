-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create user_profiles table
CREATE TABLE user_profiles (
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

-- Create location_data table
CREATE TABLE location_data (
    id SERIAL PRIMARY KEY,
    province TEXT NOT NULL,
    district TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(province, district)
);

-- Create user_activity_logs table for tracking signups
CREATE TABLE user_activity_logs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
    activity_type TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security (RLS)
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_activity_logs ENABLE ROW LEVEL SECURITY;

-- Create policies for user_profiles
CREATE POLICY "Users can view own profile"
    ON user_profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
    ON user_profiles FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
    ON user_profiles FOR INSERT
    WITH CHECK (auth.uid() = id);

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
    -- Insert into user_profiles
    INSERT INTO user_profiles (
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
    ('Central Province', 'Kabwe'),
    ('Central Province', 'Kapiri Mposhi'),
    ('Copperbelt Province', 'Ndola'),
    ('Copperbelt Province', 'Kitwe'),
    ('Eastern Province', 'Chipata'),
    ('Eastern Province', 'Petauke')
ON CONFLICT (province, district) DO NOTHING; 