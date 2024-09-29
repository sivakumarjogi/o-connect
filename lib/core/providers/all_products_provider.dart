import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:o_connect/core/models/all_products_response_model.dart';
import 'package:o_connect/core/models/response_models/profile_response_model.dart/profile_response_model.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:provider/provider.dart';

class AllProductsProvider extends ChangeNotifier {
  static bool showProduct(String productName, List<App> allApps) {
    return allApps.where((element) => element.noOfDays > 0 && element.productName == productName).isNotEmpty;
  }

  static Future<List<AppInfo>> getAllApps(BuildContext context) async {
    String? customerId = await serviceLocator<UserCacheService>().getCustomerAccountId();
    Response allAppsResponse = await ApiHelper().oesDio.get(
          '${BaseUrls.baseUrl}/$customerId/products-menu',
        );
    if (allAppsResponse.statusCode == 200) {
      List<App> allApps = allAppsFromJson(allAppsResponse.data).allApps;
      final paidApps = [
        AppInfo(
          appName: 'O-Tracker',
          androidPackageName: 'com.onpassive.otracker',
          //TODO: Change App store URL
          appStoreLink: 'https://apps.apple.com/us/app/otracker-official/id6449618729',
          assetPath: AppImages.otrackerIcon,
          iosUrlScheme: 'otracker://',
          availableInStore: false,
        ),
      ];
      List<AppInfo> freeProducts = [
        AppInfo(
          appName: 'OES',
          androidPackageName: 'com.onpassive.oes',
          appStoreLink: 'https://apps.apple.com/us/app/oes-official/id6449618729',
          assetPath: AppImages.oesIcon,
          iosUrlScheme: 'oes://',
          availableInStore: true,
        ),
        AppInfo(
          appName: 'O-Mail',
          androidPackageName: 'com.onpassive.omail',
          appStoreLink: 'https://apps.apple.com/us/app/omail-official/id6451871256',
          iosUrlScheme: 'omail://',
          assetPath: AppImages.omailIcon,
          availableInStore: false,
        ),
        AppInfo(
          appName: 'O-Trim',
          androidPackageName: 'com.onpassive.otrim',
          appStoreLink: 'https://apps.apple.com/us/app/otrim-official/id6480175945',
          iosUrlScheme: 'otrim://',
          assetPath: AppImages.otrimIcon,
          availableInStore: true,
        ),
        AppInfo(
          appName: 'O-Net',
          androidPackageName: 'com.onpassive.onet',
          //TODO: Change App store URL

          appStoreLink: 'https://apps.apple.com/us/app/onet-official/id6449618729',

          iosUrlScheme: 'onet://',
          assetPath: AppImages.onetIcon,

          availableInStore: false,
        ),
      ];
      GetProfileResponseModel? profileData = Provider.of<AuthApiProvider>(context, listen: false).profileData!;

      if (profileData.isOFounder) {
        freeProducts.insert(
            0,
            AppInfo(
              appName: 'O-Founders',
              androidPackageName: 'com.onpassive.ofounders',
              //TODO: Change App store URL

              appStoreLink: 'https://apps.apple.com/us/app/onet-official/id6449618729',

              iosUrlScheme: 'onet://',
              assetPath: AppImages.oFounderIcon,
              availableInStore: false,
            ));
      }
      List<AppInfo> filteredProducts = paidApps.where((element) => showProduct(element.appName, allApps)).toList();

      return [...filteredProducts, ...freeProducts];
    } else {
      return const [];
    }
  }
}
