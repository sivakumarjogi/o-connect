import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:o_connect/core/repository/auth_repository/o_connect_auth_repo/o_connect_auth_repo.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';

import '../../../ui/utils/base_urls.dart';

class ApiHelper {
  static final _oesDio = Dio();
  static final _oConnectDio = Dio();

  Dio get oesDio => _oesDio;

  Dio get oConnectDio => _oConnectDio;
  final int _maxRetryAttempts = 3;

  /// BASIC HEADER
  static const Map<String, dynamic> basicHeader = {
    'Accept': 'application/json',
  };

  Future<Map<String, dynamic>?> apiGetCaptcha() async {
    Options options = Options(headers: basicHeader);

    //check net connectivity check
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(msg: 'INTERNET CONNECTIVITY LOST');
      return null;
    }

    try {
      var url = "https://obsapi-qa.onpassive.com/payment/create-captcha/registration?captcha=null";

      final response = await _oesDio.get(url, options: options);

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 400) {
        return null;
      } else if (e.response!.statusCode == 403 || e.response!.statusCode == 401) {}
    }
    return null;
  }

  Future<void> updateAuthorization({
    bool clearToken = false,
  }) async {
    if (clearToken) {
      _oesDio.options.headers['Authorization'] = null;
      _oConnectDio.options.headers['Authorization'] = null;
    } else {
      String? oesTkn = await serviceLocator<UserCacheService>().getToken();
      String? oConnectTkn = await serviceLocator<UserCacheService>().getOConnectToken();

      _oesDio.options.headers['Authorization'] = 'Bearer $oesTkn';
      _oConnectDio.options.headers['Authorization'] = '$oConnectTkn';
      // await addOconnectInterceptors();
      debugPrint("the oes token $oesTkn");
      // debugPrint("the o-connect token $oConnectTkn");
    }
  }


  // Future<void> addOconnectInterceptors() async {
  //   String? oConnectTkn = await serviceLocator<UserCacheService>().getOConnectToken();
  //   debugPrint("the oconnect token is the $oConnectTkn");
  //   return _oConnectDio.interceptors.add(InterceptorsWrapper(
  //     onRequest: (options, handler) async {
  //       options.headers['Accept'] ='application/json';
  //       options.headers['Authorization'] = 'Bearer $oConnectTkn';
  //       log("requestOptions.path is the ${oConnectTkn}");
  //       log("requestOptions.path is the ${options.path}");
  //       return handler.next(options);
  //     },
  //     onError: (error, handler) async {
  //       log("error is the ${error.response?.statusCode} && ${error.error}");
  //       dynamic errorResponse = error.response?.data;
  //       if (errorResponse == null) {
  //         return handler.next(error);
  //       }
  //       // bool isTokenExpired =
  //       //     (errorResponse.containsKey("message") && errorResponse.containsKey("message") == "jwt expired") || (errorResponse.containsKey("error") && errorResponse["error"] == "Invalid Session");
  //       // log("error is the ${isTokenExpired}");
  //       log("error is the ${errorResponse.containsKey("message")}");
  //       log("error is the ${errorResponse.containsKey("message")}");
  //       // if (error.response?.data['error'] == "Unauthorised User") {
  //       log("ekjaskjfhafkjsajfffksafkjsafkjafkjsahfkasfa");
  //       OConnectAuthRepo oConnectAuthRequest = OConnectAuthRepo(Dio(), baseUrl: BaseUrls.refreshAuthorization);
  //
  //       String? oConnectRefreshToken = await serviceLocator<UserCacheService>().getOConectRefreshToken();
  //       String? oconnectAccessToken = await serviceLocator<UserCacheService>().getOConnectToken();
  //       final refressTokenHeaders = {
  //         'Content-Type': 'application/json',
  //         'refreshauthorization': oConnectRefreshToken,
  //       };
  //       final data = {
  //         "accessToken": "$oconnectAccessToken",
  //         "refreshToken": "$oConnectRefreshToken",
  //       };
  //       try {
  //         Response response = await oConnectAuthRequest.refreshOconnectToken(
  //           refressTokenHeaders,
  //           data,
  //         );
  //
  //         if (response.statusCode == 200) {
  //           String newOconnectAccessToken = response.data["data"]["accessToken"].toString();
  //           String newOconnectRefreshToken = response.data["data"]["refreshToken"].toString();
  //
  //           await serviceLocator<UserCacheService>().saveOConnectToken(newOconnectAccessToken);
  //           await serviceLocator<UserCacheService>().saveOConnectRefressToken(newOconnectRefreshToken);
  //           Map<String, dynamic>? oldHeaders = error.requestOptions.headers;
  //           oldHeaders["Authorization"] = newOconnectAccessToken;
  //           _oConnectDio.options.headers['Authorization'] = newOconnectAccessToken;
  //           RequestOptions newRequestOptions = error.requestOptions.copyWith(
  //             headers: oldHeaders,
  //           );
  //             handler.resolve(await _retry(newRequestOptions));
  //
  //           return;
  //         } else {
  //           log("Token is updated here is the error ${response.data}");
  //         }
  //       } on DioException catch (e, st) {
  //         log("Token is updated here is the error1 ${st.toString()}");
  //         log("Token is updated here is the error2 ${e.response!.data}");
  //       } catch (e, st) {
  //         log("Token is updated here is the error3 ${st.toString()}");
  //         log("Token is updated here is the error4 ${e.toString()}");
  //       }
  //       // } else {
  //       //   log("ekjaskjfhafkjsajfffksafkjsafkjafkjsahfkasfa1");
  //       //   return handler.reject(error);
  //       // }
  //       return handler.reject(error);
  //     },
  //   ));
  // }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final dio = Dio();
    String url = "${requestOptions.baseUrl}${requestOptions.path}";
    print("dnvsdkjsdhifhsdfish ${url}");
    final options = Options(
      headers: requestOptions.headers,
      method: requestOptions.method,
    );

    try {
      switch (requestOptions.method.toUpperCase()) {
        case 'GET':
          return await dio.get(url, queryParameters: requestOptions.queryParameters, options: options);
        case 'POST':
          return await dio.post(url, data: requestOptions.data, queryParameters: requestOptions.queryParameters, options: options);
        case 'PUT':
          return await dio.put(url, data: requestOptions.data, queryParameters: requestOptions.queryParameters, options: options);
        case 'DELETE':
          return await dio.delete(url, data: requestOptions.data, queryParameters: requestOptions.queryParameters, options: options);
        default:
          throw UnsupportedError("Method ${requestOptions.method} is not supported");
      }
    } on DioError catch (e) {
      debugPrint("Failed to retry request: $e");
      rethrow;
    }
  }

  Future<void> refreshOconnectToken() async {
    try {
      OConnectAuthRepo oConnectAuthRequest = OConnectAuthRepo(Dio(), baseUrl: BaseUrls.refreshAuthorization);

      String? oConnectRefreshToken = await serviceLocator<UserCacheService>().getOConectRefreshToken();
      String? oconnectAccessToken = await serviceLocator<UserCacheService>().getOConnectToken();
      final refressTokenHeaders = {'Content-Type': 'application/json', 'refreshauthorization': oConnectRefreshToken};

      final data = {"accessToken": "$oconnectAccessToken", "refreshToken": "$oConnectRefreshToken"};

      debugPrint("it called $refressTokenHeaders  &&&&&& $data");
      Response response = await oConnectAuthRequest.refreshOconnectToken(refressTokenHeaders, data);

      if (response.statusCode == 200) {
        debugPrint("the refresh token data is accessTKN1:${response.data} ");
        debugPrint("the refresh token data is accessTKN:${response.data["data"]["accessToken"]} && ${response.data["data"]["refreshToken"]} ");
        await serviceLocator<UserCacheService>().saveOConnectToken(response.data["data"]["accessToken"]);
        await serviceLocator<UserCacheService>().saveOConnectRefressToken(response.data["data"]["refreshToken"]);
        Future.delayed(const Duration(seconds: 2));
        // CustomToast.showSuccessToast(msg: "Token Refresh successfully");
      }

      debugPrint("the refress token response Data is the ${response.data}");
    } on DioException catch (e) {
      debugPrint("the error while refresh token ${e.error} && ${e.response}");
    } catch (e, st) {
      debugPrint("the error in the refresh token ${e.toString()} && $st");
    }
  }

  Future<bool> updateToken(BuildContext context) async {
    String? localToken = await serviceLocator<UserCacheService>().getToken();

    print("the local token $localToken");
    if (localToken != null) {
      try {
        var response = await Dio().get(
          "${BaseUrls.baseUrl}/refresh-token",
          options: Options(headers: {"Authorization": "Bearer $localToken"}, receiveTimeout: const Duration(milliseconds: 3000), sendTimeout: const Duration(milliseconds: 5000)),
        );
        final local = serviceLocator<UserCacheService>();
        if (response.statusCode == 200) {
          local.saveToken(response.data['data']['accessToken']);
          updateAuthorization();
          return true;
        } else if (response.statusCode == 401) {
          local.deleteToken();

          CustomToast.showErrorToast(msg: "Session Expired").then((value) {
            Navigator.pushNamedAndRemoveUntil(context, RoutesManager.logIn, (route) => false);
          });
          return false;
        }
      } on DioException catch (e) {
        if (e.response == null) {
          CustomToast.showErrorToast(msg: "No Internet");
          return true;
        }
        if (e.response!.statusCode == 500 || e.response!.statusCode == 401) {
          CustomToast.showErrorToast(msg: e.response!.statusCode == 401 ? "Session Expired" : "Something went wrong").then((value) {
            Navigator.pushNamedAndRemoveUntil(context, RoutesManager.logIn, (route) => false);
          });
          return false;
        }
        return false;
      } catch (e, st) {
        debugPrint("${e.toString()} && $st");
        CustomToast.showErrorToast(msg: "Something went wrong").then((value) {
          Navigator.pushNamedAndRemoveUntil(context, RoutesManager.logIn, (route) => false);
        });
        return false;
      }
    }
    return true;
  }

  void clearInterceptors() {
    _oesDio.options.headers['Authorization'] = null;
    _oesDio.options.headers['source'] = null;
    _oConnectDio.options.headers['Authorization'] = null;
    _oConnectDio.options.headers['source'] = null;
  }
}


//