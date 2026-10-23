-- ====================================================================
-- UZHAVAN360 Reference Seed Data (Migration 00003)
-- Authenticated reference crops and clearly labeled sample data
-- ====================================================================

-- 1. REFERENCE CROPS (Authentic Tamil Nadu Crops)
INSERT INTO public.crops (name_ta, name_en, category, standard_unit) VALUES
('நெல் (பொன்னி / ஐ.ஆர் 20)', 'Paddy (Ponni / IR 20)', 'cereals', 'quintal'),
('கரும்பு', 'Sugarcane', 'cash_crops', 'tonne'),
('மஞ்சள்', 'Turmeric', 'spices', 'quintal'),
('பருத்தி', 'Cotton', 'cash_crops', 'quintal'),
('நிலக்கடலை', 'Groundnut', 'oilseeds', 'quintal'),
('வாழை (பூவன் / நேந்திரன்)', 'Banana (Poovan / Nendran)', 'fruits', 'bunch'),
('தக்காளி', 'Tomato', 'vegetables', 'kg'),
('சின்ன வெங்காயம்', 'Small Onion (Shallots)', 'vegetables', 'kg'),
('சோளம் (மக்காச்சோளம்)', 'Maize (Corn)', 'cereals', 'quintal'),
('உளுந்து', 'Black Gram', 'pulses', 'quintal')
ON CONFLICT DO NOTHING;

-- 2. SAMPLE ADMINISTRATIVE LOCATIONS (Tamil Nadu)
INSERT INTO public.locations (district, taluk, village, pincode) VALUES
('மதுரை (Madurai)', 'வாடிப்பட்டி (Vadipatti)', 'ஆலங்கொட்டாரம் (Alangottaram)', '625218'),
('மதுரை (Madurai)', 'வாடிப்பட்டி (Vadipatti)', 'குள்ளபுரம் (Kullapuram)', '625218'),
('தஞ்சாவூர் (Thanjavur)', 'பாபநாசம் (Papanasam)', 'வழுத்தூர் (Vazhuthur)', '614210'),
('தஞ்சாவூர் (Thanjavur)', 'கும்பகோணம் (Kumbakonam)', 'தாராசுரம் (Darasuram)', '612702'),
('கோயம்புத்தூர் (Coimbatore)', 'பொள்ளாச்சி (Pollachi)', 'ஆனைமலை (Anaimalai)', '642104'),
('ஈரோடு (Erode)', 'கோபிசெட்டிபாளையம் (Gobichettipalayam)', 'கொடிவேரி (Kodiveri)', '638454')
ON CONFLICT DO NOTHING;

-- 3. OFFICIAL GOVERNMENT SCHEMES (Tamil Nadu Agriculture)
INSERT INTO public.government_schemes (
    title_ta,
    title_en,
    department,
    summary_ta,
    summary_en,
    eligibility_ta,
    eligibility_en,
    benefits_ta,
    benefits_en,
    documents_required_ta,
    documents_required_en,
    application_process_ta,
    application_process_en,
    official_portal_url,
    helpline_number
) VALUES
(
    'கலைஞரின் அனைத்து கிராம ஒருங்கிணைந்த வேளாண் வளர்ச்சி திட்டம்',
    'Kalaignarin All Village Integrated Agriculture Development Programme',
    'வேளாண்மை - உழவர் நலத்துறை (Agriculture and Farmers Welfare Dept)',
    'கிராம பஞ்சாயத்துகளில் உள்ள அனைத்து தரிசு நிலங்களையும் சாகுபடிக்கு கொண்டு வந்து, உழவர் வருமானத்தை பெருக்குதல்.',
    'Brings fallow lands into cultivation across village panchayats and enhances farmer income.',
    'அனைத்து சிறு, குறு மற்றும் ஆதிதிராவிட, பழங்குடியின விவசாயிகள்.',
    'All small, marginal, SC and ST farmers owning agricultural land in selected panchayats.',
    'இலவச பழக்கன்றுகள், தார்ப்பாய், விசைத்தெளிப்பான், நுண்ணீர் பாசனத்திற்கான 100% மானியம்.',
    'Free fruit saplings, tarpaulins, power sprayers, and 100% subsidy for micro-irrigation.',
    ARRAY['பட்டா / சிட்டா நகல்', 'ஆதார் அட்டை', 'வங்கி கணக்கு புத்தக நகல்', 'புகைப்படம்'],
    ARRAY['Patta / Chitta copy', 'Aadhaar Card', 'Bank Passbook copy', 'Passport size photo'],
    'உங்கள் வட்டார வேளாண்மை உதவி இயக்குநர் அலுவலகம் அல்லது உழவன் செயலி மூலம் விண்ணப்பிக்கலாம்.',
    'Apply via Block Assistant Director of Agriculture Office or Uzhavan App.',
    'https://www.tnagrisnet.tn.gov.in',
    '1800-425-1555'
),
(
    'பிரதம மந்திரி கிசான் சம்மான் நிதி (PM-KISAN)',
    'PM Kisan Samman Nidhi Yojana',
    'மத்திய வேளாண்மை அமைச்சகம் (Ministry of Agriculture)',
    'சிறு மற்றும் குறு விவசாயிகளுக்கு ஆண்டுக்கு ரூ. 6,000 நேரடி நிதி உதவி மூன்று தவணைகளாக வழங்கப்படுகிறது.',
    'Direct income support of Rs. 6,000 per year in three equal installments to farmer families.',
    'விவசாய நிலம் சொந்தமாக வைத்துள்ள அனைத்து விவசாய குடும்பங்கள்.',
    'All landholding farmer families with cultivable land.',
    'ஆண்டுக்கு ரூ. 6,000 (தலா ரூ. 2,000 வீதம் 3 தவணைகளில் வங்கிக் கணக்கில் வரவு வைக்கப்படும்).',
    'Rs. 6,000 annually credited directly to bank account in 3 installments.',
    ARRAY['ஆதார் அட்டை', 'நிலப் பட்டா / ஆவணங்கள்', 'ஆதார் இணைக்கப்பட்ட வங்கிக் கணக்கு'],
    ARRAY['Aadhaar Card', 'Land Patta / Ownership records', 'Aadhaar linked Bank Account'],
    'PM-KISAN இணையதளம் அல்லது இ-சேவை மையம் மூலம் விண்ணப்பிக்கலாம்.',
    'Apply online at PM-KISAN portal or through local e-Seva centres.',
    'https://pmkisan.gov.in',
    '155261'
),
(
    'பிரதம மந்திரி பயிர் காப்பீட்டுத் திட்டம் (PMFBY)',
    'Pradhan Mantri Fasal Bima Yojana (Crop Insurance)',
    'வேளாண்மை - உழவர் நலத்துறை',
    'இயற்கை சீற்றங்கள், வறட்சி, வெள்ளம் மற்றும் பூச்சித் தாக்குதலால் ஏற்படும் பயிர் இழப்பிற்கு முழுமையான காப்பீடு.',
    'Comprehensive insurance cover against crop loss due to non-preventable natural risks.',
    'அறிவிக்கப்பட்ட பகுதியில் பயிர் செய்யும் குத்தகை விவசாயிகள் உட்பட அனைத்து விவசாயிகளும்.',
    'All farmers growing notified crops in notified areas, including tenant farmers.',
    'பயிர் சேதத்திற்கு குறைந்த பிரீமியத்தில் முழுமையான இழப்பீட்டுத் தொகை வழங்கப்படுகிறது.',
    'Financial support and claim payout for crop loss at very nominal premium.',
    ARRAY['அடங்கல் / சாகுபடி சான்று', 'பட்டா / சிட்டா', 'ஆதார் அட்டை', 'வங்கி பாஸ்புக்'],
    ARRAY['Adangal / Sowing certificate', 'Patta / Chitta', 'Aadhaar Card', 'Bank Passbook'],
    'தொடர் கூட்டுறவு வங்கிகள், பொதுத்துறை வங்கிகள் அல்லது இ-சேவை மையம் வாயிலாக பதிவு செய்யவும்.',
    'Enroll through Primary Agricultural Co-op Societies, Banks, or CSC centres.',
    'https://pmfby.gov.in',
    '1800-180-1551'
)
ON CONFLICT DO NOTHING;
