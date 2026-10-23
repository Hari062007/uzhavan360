-- ====================================================================
-- UZHAVAN360 Database Security & Row Level Security (RLS) Policies
-- Migration 00002
-- ====================================================================

-- 1. PROFILES RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public profiles are viewable by authenticated users"
ON public.profiles FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Users can insert their own profile"
ON public.profiles FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
ON public.profiles FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (
    auth.uid() = id AND
    -- Prevent users from self-elevating their official status!
    is_official_verified = (SELECT is_official_verified FROM public.profiles WHERE id = auth.uid())
);

-- 2. USER ROLES RLS
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own roles"
ON public.user_roles FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY "Users can assign basic roles to themselves"
ON public.user_roles FOR INSERT
TO authenticated
WITH CHECK (
    auth.uid() = user_id AND
    role IN ('worker', 'landowner', 'trader') AND
    is_verified = FALSE
);

CREATE POLICY "Panchayat Official role request insertion"
ON public.user_roles FOR INSERT
TO authenticated
WITH CHECK (
    auth.uid() = user_id AND
    role = 'panchayat_official' AND
    is_verified = FALSE -- Must remain unverified until audited
);

-- 3. JOBS RLS
ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone authenticated can view active jobs"
ON public.jobs FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Landowners/Employers can create jobs"
ON public.jobs FOR INSERT
TO authenticated
WITH CHECK (
    auth.uid() = employer_id AND
    EXISTS (
        SELECT 1 FROM public.user_roles
        WHERE user_id = auth.uid() AND role IN ('landowner', 'worker')
    )
);

CREATE POLICY "Employers can update their own jobs"
ON public.jobs FOR UPDATE
TO authenticated
USING (auth.uid() = employer_id);

CREATE POLICY "Employers can delete their own jobs"
ON public.jobs FOR DELETE
TO authenticated
USING (auth.uid() = employer_id);

-- 4. JOB APPLICATIONS RLS
ALTER TABLE public.job_applications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Workers can view their own applications and employers can view applications for their jobs"
ON public.job_applications FOR SELECT
TO authenticated
USING (
    auth.uid() = worker_id OR
    EXISTS (
        SELECT 1 FROM public.jobs
        WHERE jobs.id = job_applications.job_id AND jobs.employer_id = auth.uid()
    )
);

CREATE POLICY "Workers can apply for open jobs"
ON public.job_applications FOR INSERT
TO authenticated
WITH CHECK (
    auth.uid() = worker_id AND
    EXISTS (
        SELECT 1 FROM public.jobs
        WHERE jobs.id = job_applications.job_id AND jobs.status = 'open'
    )
);

CREATE POLICY "Workers can cancel own application or Employers can update status"
ON public.job_applications FOR UPDATE
TO authenticated
USING (
    auth.uid() = worker_id OR
    EXISTS (
        SELECT 1 FROM public.jobs
        WHERE jobs.id = job_applications.job_id AND jobs.employer_id = auth.uid()
    )
);

-- 5. CROP PRICE LISTINGS (Trader Offers) RLS
ALTER TABLE public.crop_price_listings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Everyone authenticated can view crop price listings"
ON public.crop_price_listings FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Traders can insert their own price listings"
ON public.crop_price_listings FOR INSERT
TO authenticated
WITH CHECK (
    auth.uid() = trader_id AND
    EXISTS (
        SELECT 1 FROM public.user_roles
        WHERE user_id = auth.uid() AND role = 'trader'
    )
);

CREATE POLICY "Traders can update their own price listings"
ON public.crop_price_listings FOR UPDATE
TO authenticated
USING (auth.uid() = trader_id);

-- 6. ACTUAL CROP TRANSACTIONS RLS
ALTER TABLE public.crop_transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Everyone can view verified transactions and own reported transactions"
ON public.crop_transactions FOR SELECT
TO authenticated
USING (is_verified = TRUE OR reported_by = auth.uid());

CREATE POLICY "Users can report transactions"
ON public.crop_transactions FOR INSERT
TO authenticated
WITH CHECK (
    reported_by = auth.uid() AND
    is_verified = FALSE -- Cannot self-verify transactions!
);

-- 7. GOVERNMENT SCHEMES RLS
ALTER TABLE public.government_schemes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can view active government schemes"
ON public.government_schemes FOR SELECT
TO authenticated
USING (is_active = TRUE);

-- 8. SCHEME BOOKMARKS RLS
ALTER TABLE public.scheme_bookmarks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their own bookmarks"
ON public.scheme_bookmarks FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- 9. VILLAGE ANNOUNCEMENTS RLS
ALTER TABLE public.village_announcements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can view village announcements"
ON public.village_announcements FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Only verified officials can create announcements"
ON public.village_announcements FOR INSERT
TO authenticated
WITH CHECK (
    auth.uid() = official_id AND
    EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = auth.uid() AND is_official_verified = TRUE
    )
);

-- 10. PUBLIC FUND RECORDS (Gram Panchayat Transparency) RLS
ALTER TABLE public.public_fund_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can view public fund records"
ON public.public_fund_records FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Only verified officials can insert or update public fund records"
ON public.public_fund_records FOR INSERT
TO authenticated
WITH CHECK (
    auth.uid() = official_id AND
    EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = auth.uid() AND is_official_verified = TRUE
    )
);

-- 11. VILLAGE COMPLAINTS RLS (Strict Privacy Protection)
ALTER TABLE public.village_complaints ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Citizens can view only their own complaints, verified officials can view their village complaints"
ON public.village_complaints FOR SELECT
TO authenticated
USING (
    citizen_id = auth.uid() OR
    EXISTS (
        SELECT 1 FROM public.profiles p
        WHERE p.id = auth.uid() AND p.is_official_verified = TRUE AND p.village = village_complaints.village
    )
);

CREATE POLICY "Citizens can submit complaints"
ON public.village_complaints FOR INSERT
TO authenticated
WITH CHECK (citizen_id = auth.uid());

CREATE POLICY "Verified officials can update complaint resolution"
ON public.village_complaints FOR UPDATE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.profiles p
        WHERE p.id = auth.uid() AND p.is_official_verified = TRUE AND p.village = village_complaints.village
    )
);
