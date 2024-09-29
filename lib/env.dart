// ignore_for_file: non_constant_identifier_names

enum BuildFlavor { development, qa, security, performance, preprod, production }

BuildEnvironment? get env => _env;
BuildEnvironment? _env;
String OFOUNDER_PROD_LOGIN_URL = 'https://obsapi.onpassive.com';
String OFOUNDER_QA_LOGIN_URL = 'https://obsapi-qa.onpassive.com';
String OFOUNDER_DEV_LOGIN_URL = 'https://obsapi-dev.onpassive.com';

String get orgId => env?.flavor == BuildFlavor.production
    ? '1'
    : env?.flavor == BuildFlavor.development
        ? '994'
        : env?.flavor == BuildFlavor.qa
            ? '1048'
            : '1';

String get ofounderLoginUrl => env?.flavor == BuildFlavor.production
    ? OFOUNDER_PROD_LOGIN_URL
    : env?.flavor == BuildFlavor.development
        ? OFOUNDER_DEV_LOGIN_URL
        : env?.flavor == BuildFlavor.qa
            ? OFOUNDER_QA_LOGIN_URL
            : OFOUNDER_PROD_LOGIN_URL;

class BuildEnvironment {
  /// The backend server.
  final String baseUrl;
  final BuildFlavor flavor;
  final String imageUrl;
  final String toBeAppended;
  final String deskUrl;
  final String chatBotUrl;
  final String chatBotSaveUrl;
  String checkoutApiUrl;
  final String checkoutPublicKey;
  final String assetsUrl;
  final String rocketFuelFormUrl;

  BuildEnvironment._init({
    required this.flavor,
    required this.baseUrl,
    required this.imageUrl,
    required this.deskUrl,
    required this.chatBotUrl,
    required this.chatBotSaveUrl,
    required this.toBeAppended,
    required this.checkoutApiUrl,
    required this.checkoutPublicKey,
    required this.assetsUrl,
    required this.rocketFuelFormUrl,
  });

  /// Sets up the top-level [env?] getter on the first call only.
  static void init(
          {required flavor,
          required baseUrl,
          required imageUrl,
          required deskUrl,
          required toBeAppended,
          required chatBotUrl,
          required chatBotSaveUrl,
          checkoutApiUrl,
          required checkoutPublicKey,
          required assetsUrl,
          required rocketFuelFormUrl}) =>
      _env ??= BuildEnvironment._init(
        flavor: flavor,
        baseUrl: baseUrl,
        imageUrl: imageUrl,
        deskUrl: deskUrl,
        chatBotUrl: chatBotUrl,
        chatBotSaveUrl: chatBotSaveUrl,
        toBeAppended: toBeAppended,
        checkoutApiUrl: checkoutApiUrl,
        checkoutPublicKey: checkoutPublicKey,
        assetsUrl: assetsUrl,
        rocketFuelFormUrl: rocketFuelFormUrl,
      );
}
