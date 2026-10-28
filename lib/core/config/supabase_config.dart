/// Supabase Backend Configuration for UZHAVAN360.
///
/// Configure your Supabase project credentials either:
/// 1. Via compile-time environment flags:
///    flutter build apk --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key
/// 2. Or by replacing the default values below with your project credentials from
///    Supabase Dashboard -> Settings -> API.
class SupabaseConfig {
  static const String _defaultUrl = 'https://xyzcompanyuzhavan360.supabase.co';
  static const String _defaultKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.dummy_public_key_for_setup';

  /// Supabase Project URL
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: _defaultUrl,
  );

  /// Supabase Anon (Public) Key
  /// NEVER place the service_role key here. Only anon public key is allowed in mobile clients.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: _defaultKey,
  );

  /// Returns true only if genuine Supabase credentials have been configured.
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty &&
      supabaseAnonKey.isNotEmpty &&
      supabaseUrl != _defaultUrl &&
      supabaseAnonKey != _defaultKey;
}
