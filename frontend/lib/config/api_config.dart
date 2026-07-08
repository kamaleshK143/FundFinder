class ApiConfig {
  /// Overridable at build/run time: flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
}
