-- ====================================================================
-- UZHAVAN360 Database Schema (Migration 00001)
-- Rural Empowerment Platform for Tamil Nadu Communities
-- ====================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. PROFILES TABLE
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    phone_number TEXT NOT NULL UNIQUE,
    full_name TEXT,
    avatar_url TEXT,
    district TEXT,
    taluk TEXT,
    village TEXT,
    preferred_language TEXT DEFAULT 'ta',
    is_official_verified BOOLEAN DEFAULT FALSE,
    is_adviser_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. USER ROLES TABLE (Allows a single user to hold multiple authorized roles)
CREATE TABLE IF NOT EXISTS public.user_roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('worker', 'landowner', 'trader', 'panchayat_official')),
    is_verified BOOLEAN DEFAULT FALSE, -- Crucial: panchayat_official requires verification
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, role)
);

-- 3. ADMINISTRATIVE LOCATIONS (Districts, Taluks, Panchayats/Villages)
CREATE TABLE IF NOT EXISTS public.locations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    district TEXT NOT NULL,
    taluk TEXT NOT NULL,
    village TEXT NOT NULL,
    pincode TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    UNIQUE(district, taluk, village)
);

-- 4. CROPS REFERENCE
CREATE TABLE IF NOT EXISTS public.crops (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_ta TEXT NOT NULL,
    name_en TEXT NOT NULL,
    category TEXT NOT NULL, -- cereals, pulses, vegetables, fruits, cash_crops
    standard_unit TEXT DEFAULT 'quintal', -- kg, quintal, bag, tonne
    image_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. TRADER CROP OFFER PRICES (Trader quoted prices - NOT actual completed transactions)
CREATE TABLE IF NOT EXISTS public.crop_price_listings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    trader_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    crop_id UUID NOT NULL REFERENCES public.crops(id) ON DELETE CASCADE,
    crop_name_ta TEXT NOT NULL,
    crop_name_en TEXT NOT NULL,
    district TEXT NOT NULL,
    market_or_village TEXT NOT NULL,
    price_unit TEXT NOT NULL DEFAULT 'quintal', -- kg or quintal
    grade_1_price NUMERIC(10, 2) NOT NULL, -- First quality
    grade_2_price NUMERIC(10, 2) NOT NULL, -- Second quality
    grade_3_price NUMERIC(10, 2) NOT NULL, -- Third quality
    notes TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. ACTUAL COMPLETED CROP TRANSACTIONS (Mandatory separation from offer quotes)
CREATE TABLE IF NOT EXISTS public.crop_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    crop_id UUID NOT NULL REFERENCES public.crops(id) ON DELETE CASCADE,
    crop_name TEXT NOT NULL,
    quality_grade TEXT NOT NULL CHECK (quality_grade IN ('grade_1', 'grade_2', 'grade_3')),
    transaction_price NUMERIC(10, 2) NOT NULL,
    price_unit TEXT NOT NULL DEFAULT 'quintal',
    quantity_sold NUMERIC(10, 2),
    market_or_village TEXT NOT NULL,
    district TEXT NOT NULL,
    transaction_date DATE NOT NULL DEFAULT CURRENT_DATE,
    reported_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    source TEXT NOT NULL, -- 'regulated_market', 'trader_direct', 'farmer_sale'
    is_verified BOOLEAN DEFAULT FALSE,
    verified_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. AGRICULTURAL JOBS
CREATE TABLE IF NOT EXISTS public.jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employer_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title_ta TEXT NOT NULL,
    title_en TEXT NOT NULL,
    work_type TEXT NOT NULL, -- harvesting, sowing, weeding, plowing, pesticide_spraying, machinery
    district TEXT NOT NULL,
    taluk TEXT NOT NULL,
    village TEXT NOT NULL,
    work_date DATE NOT NULL,
    working_hours TEXT DEFAULT '8:00 AM - 2:00 PM',
    workers_required INT NOT NULL CHECK (workers_required > 0),
    workers_hired INT DEFAULT 0,
    wage_amount NUMERIC(10, 2) NOT NULL,
    wage_basis TEXT NOT NULL DEFAULT 'daily', -- daily, per_acre, per_kg
    description TEXT,
    contact_phone TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'filled', 'cancelled', 'completed')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. JOB APPLICATIONS
CREATE TABLE IF NOT EXISTS public.job_applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    job_id UUID NOT NULL REFERENCES public.jobs(id) ON DELETE CASCADE,
    worker_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    share_contact_consent BOOLEAN NOT NULL DEFAULT FALSE,
    contact_phone TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected', 'cancelled')),
    applied_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(job_id, worker_id)
);

-- 9. GOVERNMENT SCHEMES
CREATE TABLE IF NOT EXISTS public.government_schemes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title_ta TEXT NOT NULL,
    title_en TEXT NOT NULL,
    department TEXT NOT NULL,
    summary_ta TEXT NOT NULL,
    summary_en TEXT NOT NULL,
    eligibility_ta TEXT NOT NULL,
    eligibility_en TEXT NOT NULL,
    benefits_ta TEXT NOT NULL,
    benefits_en TEXT NOT NULL,
    documents_required_ta TEXT[] NOT NULL,
    documents_required_en TEXT[] NOT NULL,
    application_process_ta TEXT NOT NULL,
    application_process_en TEXT NOT NULL,
    official_portal_url TEXT,
    helpline_number TEXT,
    deadline_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 10. SCHEME BOOKMARKS
CREATE TABLE IF NOT EXISTS public.scheme_bookmarks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    scheme_id UUID NOT NULL REFERENCES public.government_schemes(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, scheme_id)
);

-- 11. VILLAGE ANNOUNCEMENTS (Gram Panchayat)
CREATE TABLE IF NOT EXISTS public.village_announcements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    official_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    district TEXT NOT NULL,
    taluk TEXT NOT NULL,
    village TEXT NOT NULL,
    title_ta TEXT NOT NULL,
    title_en TEXT NOT NULL,
    content_ta TEXT NOT NULL,
    content_en TEXT NOT NULL,
    category TEXT NOT NULL DEFAULT 'general', -- general, health, water, agriculture, power_cut, urgent
    is_urgent BOOLEAN DEFAULT FALSE,
    broadcast_sms BOOLEAN DEFAULT FALSE,
    broadcast_voice BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    expires_at TIMESTAMPTZ
);

-- 12. GRAM SABHA MEETINGS
CREATE TABLE IF NOT EXISTS public.gram_sabha_meetings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    official_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    district TEXT NOT NULL,
    taluk TEXT NOT NULL,
    village TEXT NOT NULL,
    meeting_date DATE NOT NULL,
    meeting_time TEXT NOT NULL,
    venue TEXT NOT NULL,
    agenda_ta TEXT NOT NULL,
    agenda_en TEXT NOT NULL,
    resolutions_summary_ta TEXT,
    resolutions_summary_en TEXT,
    status TEXT DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'ongoing', 'concluded', 'postponed')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 13. PUBLIC WORKS & FUND ALLOCATION RECORDS (Financial Transparency)
CREATE TABLE IF NOT EXISTS public.public_fund_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    official_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    financial_year TEXT NOT NULL, -- e.g., '2025-2026'
    project_name_ta TEXT NOT NULL,
    project_name_en TEXT NOT NULL,
    district TEXT NOT NULL,
    taluk TEXT NOT NULL,
    village TEXT NOT NULL,
    funding_source TEXT NOT NULL, -- e.g., '15th Finance Commission', 'MGNREGA', 'State Fund'
    allocated_amount NUMERIC(14, 2) NOT NULL,
    spent_amount NUMERIC(14, 2) NOT NULL DEFAULT 0.00,
    remaining_amount NUMERIC(14, 2) GENERATED ALWAYS AS (allocated_amount - spent_amount) STORED,
    project_status TEXT NOT NULL DEFAULT 'in_progress' CHECK (project_status IN ('tender_phase', 'in_progress', 'completed', 'halted')),
    reference_document_url TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    verified_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 14. VILLAGE COMPLAINTS & GRIEVANCES
CREATE TABLE IF NOT EXISTS public.village_complaints (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    citizen_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    district TEXT NOT NULL,
    taluk TEXT NOT NULL,
    village TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('drinking_water', 'street_light', 'drainage', 'road', 'sanitation', 'agriculture', 'other')),
    description TEXT NOT NULL,
    image_url TEXT,
    status TEXT NOT NULL DEFAULT 'submitted' CHECK (status IN ('submitted', 'under_review', 'action_taken', 'resolved', 'rejected')),
    official_response TEXT,
    resolved_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 15. EXPERIENCED FARMER / ADVISER PROFILES
CREATE TABLE IF NOT EXISTS public.adviser_profiles (
    id UUID PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
    specializations TEXT[] NOT NULL, -- organic_farming, pest_management, drip_irrigation, horticulture, livestock
    experience_years INT NOT NULL,
    available_hours TEXT DEFAULT '5:00 PM - 7:00 PM',
    rating NUMERIC(3, 2) DEFAULT 5.0,
    reviews_count INT DEFAULT 0,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 16. FARMER ASSISTANCE REQUESTS
CREATE TABLE IF NOT EXISTS public.assistance_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    farmer_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    adviser_id UUID NOT NULL REFERENCES public.adviser_profiles(id) ON DELETE CASCADE,
    crop_name TEXT NOT NULL,
    problem_description TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'connected', 'resolved', 'closed')),
    call_duration_seconds INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 17. OFFICIAL VERIFICATION AUDIT LOGS
CREATE TABLE IF NOT EXISTS public.official_verification_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    office_designation TEXT NOT NULL,
    panchayat_name TEXT NOT NULL,
    id_card_url TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    reviewed_by UUID REFERENCES public.profiles(id),
    reviewed_at TIMESTAMPTZ,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- INDEXES FOR HIGH QUERY PERFORMANCE
CREATE INDEX IF NOT EXISTS idx_jobs_location ON public.jobs(district, taluk, village);
CREATE INDEX IF NOT EXISTS idx_jobs_status ON public.jobs(status);
CREATE INDEX IF NOT EXISTS idx_crop_listings ON public.crop_price_listings(district, market_or_village, is_active);
CREATE INDEX IF NOT EXISTS idx_transactions_crop ON public.crop_transactions(crop_id, transaction_date);
CREATE INDEX IF NOT EXISTS idx_announcements_location ON public.village_announcements(district, taluk, village);
CREATE INDEX IF NOT EXISTS idx_complaints_citizen ON public.village_complaints(citizen_id);
CREATE INDEX IF NOT EXISTS idx_complaints_location ON public.village_complaints(district, taluk, village);
