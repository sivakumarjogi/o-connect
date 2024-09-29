// To parse this JSON data, do
//
//     final allApps = allAppsFromJson(jsonString);

class AppInfo {
  final String appName;
  final String androidPackageName;
  final String appStoreLink;
  final String? iosUrlScheme;
  final String assetPath;

  // Indicated whether app is available on stores for download
  final bool availableInStore;

  AppInfo({
    required this.appName,
    required this.androidPackageName,
    required this.appStoreLink,
    required this.assetPath,
    required this.availableInStore,
    this.iosUrlScheme,
  });
}

AllApps allAppsFromJson(dynamic str) => AllApps.fromJson((str));

class AllApps {
  int statusCode;
  String status;
  String message;
  dynamic data;
  List<App> allApps;
  dynamic totalCount;

  AllApps({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
    required this.allApps,
    required this.totalCount,
  });

  factory AllApps.fromJson(Map<String, dynamic> json) => AllApps(
        statusCode: json["statusCode"],
        status: json["status"],
        message: json["message"],
        data: json["data"],
        allApps: List<App>.from(json["body"].map((x) => App.fromJson(x))),
        totalCount: json["totalCount"],
      );
}

class App {
  int noOfDays;
  // String subsEndDate;
  String productName;
  int productId;
  String logo;
  String path;
  int isTrial;

  App({
    required this.noOfDays,
    // required this.subsEndDate,
    required this.productName,
    required this.productId,
    required this.logo,
    required this.path,
    required this.isTrial,
  });

  factory App.fromJson(Map<String, dynamic> json) => App(
        noOfDays: json["no_of_days"],
        // subsEndDate:
        //     DateFormat('MMMM yyyy').format(DateTime.parse(json["subsEndDate"])),
        productName: json["productName"],
        productId: json["productId"],
        logo: json["logo"],
        path: json["path"],
        isTrial: json["is_trial"],
      );
}
