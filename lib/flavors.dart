enum Flavor { development, prod }

const String app = 'Moni Pod';

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.development:
        return app;
      case Flavor.prod:
        return app;
      default:
        return app;
    }
  }

  static String get envFileName => 'assets/${appFlavor?.name}.config.json';
}
