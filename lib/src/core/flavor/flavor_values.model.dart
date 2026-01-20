class FlavorValues {
  const FlavorValues({
    required this.baseUrl,
    required Map<String, dynamic> Function() features,
    required this.isFirebaseEnabled,
  }) : _features = features;

  final String baseUrl;
  final bool isFirebaseEnabled;
  final Map<String, dynamic> Function() _features;

  Map<String, dynamic> get features => _features();
}
