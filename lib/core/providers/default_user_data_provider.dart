import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:o_connect/core/models/default_user_data_model.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';

class DefaultUserDataProvider extends ChangeNotifier {
  DefaultUserDataModel? defaultUserDataModel;

  set setUserDataModel(dynamic userJsonData) {
    if (userJsonData != null) {
      try {
        defaultUserDataModel = DefaultUserDataModel.fromJson(userJsonData);

        notifyListeners();
      } catch (e, st) {
        print("the error is the ${e.toString()} && $st");
        CustomToast.showErrorToast(msg: "Error While parsing data");
      }
    }
  }

  Future getSetAsDefaultData({required BuildContext context}) async {
    String? userData = await serviceLocator<UserCacheService>().getUserData('userData');
    var userId = jsonDecode(userData ?? "")["id"];
    String url = '${BaseUrls.getDefaultDataUrl}/$userId';
    print("the response data is the ${url.toString()}");
    try {
      Response response = await ApiHelper().oConnectDio.get(url);
      print("the response data is the ${response.data.toString()}");
      setUserDataModel = response.data["data"];
    } on DioException catch (e, st) {
      debugPrint("the Dio error while fetchinf user Data ${e.error} && ${e.response} && $st");
      CustomToast.showErrorToast(msg: "Error while fetching user Default Data");
    } catch (e, st) {
      debugPrint("the error while fetching data ${e.toString()} && $st");
    }
  }

  Future<void> changeDefaultExitUrl({required String defaultExitUrl}) async {
    if (defaultUserDataModel != null) {
      defaultUserDataModel = defaultUserDataModel!.copyWith(
          data: defaultUserDataModel!.data?.copyWith(
        exitUrl: defaultExitUrl,
      ));
      print(defaultUserDataModel!.toJson());
      await changeUserDefaultData();
      notifyListeners();
    }
  }

  Future changeUserDefaultData() async {
    Response response = await ApiHelper().oConnectDio.post(
          BaseUrls.addDefaultDataUrl,
          data: defaultUserDataModel?.data?.toJson(),
        );

    print(response.data.toString());
    if (response.statusCode != 200) {
      CustomToast.showErrorToast(msg: "Failed to update user default data");
      return;
    } else {
      print("Default Data updated");
    }
  }

  Future updateCallToAction({
    required String buttonTxt,
    required String buttonUrl,
    required int displayTime,
    required String title,
    required String titleBgClr,
    required String titleClr,
    required String btnBgClr,
    required String btnClr,
  }) async {
    defaultUserDataModel = defaultUserDataModel!.copyWith(
      data: defaultUserDataModel!.data?.copyWith(
        cta: Cta(
          buttonTxt: buttonTxt,
          buttonUrl: buttonUrl,
          displayTime: displayTime,
          title: title,
          titleBgClr: titleBgClr,
          titleClr: titleClr,
          btnBgClr: btnBgClr,
          btnClr: btnClr,
        ),
      ),
    );
    await changeUserDefaultData();
    notifyListeners();
  }

  Future updatePushLink({
    String buttonUrl = "",
    String buttonText = "",
  }) async {
    defaultUserDataModel = defaultUserDataModel!.copyWith(
      data: defaultUserDataModel!.data?.copyWith(
        pushALink: defaultUserDataModel!.data?.pushALink?.copyWith(
          button: buttonText,
          link: buttonUrl,
        ),
      ),
    );
    await changeUserDefaultData();
  }

  Future updateTicker({
    String tickerData = "",
  }) async {
    defaultUserDataModel = defaultUserDataModel?.copyWith(
      data: defaultUserDataModel?.data?.copyWith(
        ticker: defaultUserDataModel?.data?.ticker?.copyWith(
          ticker: tickerData.toString(),
        ),
      ),
    );
    print("dfsdfdsf   ${defaultUserDataModel?.data?.ticker.toString()}");
    await changeUserDefaultData();
  }
}
