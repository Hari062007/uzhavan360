class SupabaseConfig {
  /// Supabase Project URL
  /// Replace with your project URL from Supabase Dashboard -> Settings -> API
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xyzcompanyuzhavan360.supabase.co',
  );

  /// Supabase Anon (Public) Key
  /// NEVER place the service_role key here. Only anon public key is allowed in mobile clients.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.dummy_public_key_for_setup',
  );

  /// Check whether credentials have been configured
  static bool get isConfigured =>
      supabaseUrl != 'https://xyzcompanyuzhavan360.supabase.co' &&
      supabaseAnonKey != 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.dummy_public_key_for_setup';
}
