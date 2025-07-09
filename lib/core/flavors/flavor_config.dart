enum Flavor { dev, stag, prod }

class FlavorConfig {
  FlavorConfig._({
    required this.flavor,
    required this.name,
    required this.baseUrl,
  });

  final Flavor flavor;
  final String name;
  final String baseUrl;

  static FlavorConfig? _instance;

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

  static bool isDev(String env) => env == Flavor.dev.name;

  static bool isStag(String env) => env == Flavor.stag.name;

  static bool isProd(String env) => env == Flavor.prod.name;
}
