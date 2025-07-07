enum Flavor { dev, staging, prod }

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String baseUrl;

  static FlavorConfig? _instance;

  FlavorConfig._({
    required this.flavor,
    required this.name,
    required this.baseUrl,
  });

  factory FlavorConfig({
    required Flavor flavor,
    required String name,
    required String baseUrl,
  }) {
    _instance ??= FlavorConfig._(flavor: flavor, name: name, baseUrl: baseUrl);
    return _instance!;
  }

  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception('Not initialized flavor config!');
    }
    return _instance!;
  }

  static bool isDev() => instance.flavor == Flavor.dev;

  static bool isStaging() => instance.flavor == Flavor.staging;

  static bool isProd() => instance.flavor == Flavor.prod;
}
