// enum BuildFlavor { production, development, qa }
//
// BuildEnvironment get env => _env!;
// BuildEnvironment? _env;
//
// class BuildEnvironment {
//   /// The backend server.
//   final String baseUrl;
//   final BuildFlavor flavor;
//   final String imageUrl;
//   final String toBeAppended;
//   final String deskUrl;
//   final String chatBotUrl;
//   final String chatBotSaveUrl;
//   final String checkoutApiUrl;
//   final String checkoutPublicKey;
//   final String assetsUrl;
//   final String oConnectAuthBaseUrl;
//
//   BuildEnvironment._init(
//       {required this.flavor,
//         required this.baseUrl,
//         required this.imageUrl,
//         required this.deskUrl,
//         required this.chatBotUrl,
//         required this.chatBotSaveUrl,
//         required this.toBeAppended,
//         required this.checkoutApiUrl,
//         required this.checkoutPublicKey,
//         required this.assetsUrl,
//       required this.oConnectAuthBaseUrl});
//
//   /// Sets up the top-level [env] getter on the first call only.
//   static void init(
//       {required flavor,
//         required baseUrl,
//         required imageUrl,
//         required deskUrl,
//         required toBeAppended,
//         required chatBotUrl,
//         required chatBotSaveUrl,
//         required checkoutApiUrl,
//         required checkoutPublicKey,
//         required assetsUrl,
//       required oOconnectAuthBaseUrl }) =>
//       _env ??= BuildEnvironment._init(
//         flavor: flavor,
//         baseUrl: baseUrl,
//         imageUrl: imageUrl,
//         deskUrl: deskUrl,
//         chatBotUrl: chatBotUrl,
//         chatBotSaveUrl: chatBotSaveUrl,
//         toBeAppended: toBeAppended,
//         checkoutApiUrl: checkoutApiUrl,
//         checkoutPublicKey: checkoutPublicKey,
//         assetsUrl: assetsUrl,
//         oConnectAuthBaseUrl: oOconnectAuthBaseUrl
//       );
// }
