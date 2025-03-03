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
    user_type TEXT DEFAULT 'farmer' CHECK (user_type IN ('farmer', 'buyer', 'admin')),
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create farms table
CREATE TABLE farms (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    owner_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
    farm_name TEXT NOT NULL,
    location TEXT,
    size_in_hectares DECIMAL,
    province TEXT,
    district TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create crops table
CREATE TABLE crops (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    farm_id UUID REFERENCES farms(id) ON DELETE CASCADE,
    crop_name TEXT NOT NULL,
    variety TEXT,
    planting_date DATE,
    expected_harvest_date DATE,
    status TEXT DEFAULT 'growing' CHECK (status IN ('growing', 'harvested', 'failed')),
    quantity_planted DECIMAL,
    quantity_unit TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create harvest_records table
CREATE TABLE harvest_records (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    crop_id UUID REFERENCES crops(id) ON DELETE CASCADE,
    harvest_date DATE NOT NULL,
    quantity_harvested DECIMAL,
    quality_grade TEXT,
    notes TEXT,
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

-- Create user_activity_logs table
CREATE TABLE user_activity_logs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
    activity_type TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create market_prices table
CREATE TABLE market_prices (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    crop_name TEXT NOT NULL,
    province TEXT NOT NULL,
    district TEXT NOT NULL,
    price_per_unit DECIMAL NOT NULL,
    unit TEXT NOT NULL,
    price_date DATE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create weather_data table
CREATE TABLE weather_data (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    province TEXT NOT NULL,
    district TEXT NOT NULL,
    temperature DECIMAL,
    humidity DECIMAL,
    rainfall DECIMAL,
    weather_date DATE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security (RLS)
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE farms ENABLE ROW LEVEL SECURITY;
ALTER TABLE crops ENABLE ROW LEVEL SECURITY;
ALTER TABLE harvest_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_activity_logs ENABLE ROW LEVEL SECURITY;

-- Create policies for user_profiles
CREATE POLICY "Users can view own profile"
    ON user_profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
    ON user_profiles FOR UPDATE
    USING (auth.uid() = id);

-- Create policies for farms
CREATE POLICY "Users can view own farms"
    ON farms FOR SELECT
    USING (auth.uid() = owner_id);

CREATE POLICY "Users can create own farms"
    ON farms FOR INSERT
    WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update own farms"
    ON farms FOR UPDATE
    USING (auth.uid() = owner_id);

-- Create policies for crops
CREATE POLICY "Users can view own crops"
    ON crops FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM farms 
        WHERE farms.id = crops.farm_id 
        AND farms.owner_id = auth.uid()
    ));

-- Create stored procedures
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
        'New farmer registration completed'
    );
END;
$$;

-- Create function to handle updated_at
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
CREATE TRIGGER set_user_profiles_updated_at
    BEFORE UPDATE ON user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_farms_updated_at
    BEFORE UPDATE ON farms
    FOR EACH ROW
    EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_crops_updated_at
    BEFORE UPDATE ON crops
    FOR EACH ROW
    EXECUTE FUNCTION handle_updated_at();

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

-- Insert initial location data
INSERT INTO location_data (province, district) VALUES
    ('Central Province', 'Kabwe'),
    ('Central Province', 'Kapiri Mposhi'),
    ('Copperbelt Province', 'Ndola'),
    ('Copperbelt Province', 'Kitwe'),
    ('Eastern Province', 'Chipata'),
    ('Eastern Province', 'Petauke')
ON CONFLICT (province, district) DO NOTHING; 