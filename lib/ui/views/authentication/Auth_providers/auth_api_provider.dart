// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:o_connect/core/encryption_helper.dart';
import 'package:o_connect/core/models/dummy_models/dummy_model.dart';
import 'package:o_connect/core/models/faq_model/faq_model.dart';
import 'package:o_connect/core/models/response_models/profile_response_model.dart/profile_response_model.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/repository/auth_repository/auth_api_repo.dart';
import 'package:o_connect/core/repository/auth_repository/o_connect_auth_repo/o_connect_auth_repo.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/loading_helper/loading_indicator.dart';
import 'package:o_connect/ui/views/authentication/signin_signup/CaptchaModel.dart';
import 'package:o_connect/ui/views/home_screen/home_repository/home_repository.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_models/user_subscription_model.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_view/widgets/check_subscription_pop_up.dart';
import 'package:o_connect/ui/views/profile_screen/get_profile_repoistory/get_profile_api_repo.dart';
import 'package:o_connect/ui/views/profile_screen/profile_model/updtaeuser_response_model.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApiProvider extends BaseProvider {
  late TextEditingController emailController;
  late TextEditingController emailControllerOTP;
  late TextEditingController passwordController;
  late TextEditingController usernameController;
  final TextEditingController captchaController = TextEditingController();

  AuthApiRepository apiRepository =
      AuthApiRepository(ApiHelper().oesDio, baseUrl: BaseUrls.baseUrl);

  OConnectAuthRepo oConnectAuthRequest = OConnectAuthRepo(ApiHelper().oesDio,
      baseUrl: BaseUrls.tokenGenerateBaseUrl);

  HomeApiRepository oesRequest =
      HomeApiRepository(ApiHelper().oesDio, baseUrl: BaseUrls.baseUrl);

  ApiHelper apiHelper = ApiHelper();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isOtpRequestLoading = false;
  bool isOtpValidingLoading = false;
  bool isChangePasswordLoading = false;
  bool isOtpRequestLoding = false;
  ValidatePassWord passwordValidState = ValidatePassWord();
  bool isOtpPasswordStatus = false;
  bool resendButtonForOtpLogin = false;
  bool otpValidationVisible = false;
  String completedPin = "";
  bool passObsureSignIn = false;
  bool ignoreImage = false;
  bool passObsureSignUp = false;
  bool confirmPassObsureSignUp = false;
  bool passObsureChangePwd = false;
  bool confirmPassObsureChangePwd = false;
  bool enableResendButtonForLoginOtp = false;
  bool enableResendButtonForgotPassword = false;
  bool enableConfirmPasswordFeild = false;
  var captchaModel = CaptchaModel();

  List<FaqList> faqsList = [];
  List<FaqList> finalUpdatedFaqList = [];
  GetUpdateUserResponseModel? updateUserData;
  GetProfileResponseModel? profileData;

  GetProfileApi getProfileApi =
      GetProfileApi(ApiHelper().oesDio, baseUrl: BaseUrls.baseUrl);
  GetProfileApi getFaQApi = GetProfileApi(ApiHelper().oesDio,
      baseUrl: "https://qdiulndjdb.execute-api.ap-south-1.amazonaws.com/qaold");

  String? tempRandomToken;
  List suggestionsUserNamesList = [];
  bool isLoading = false;

  void apiGetCaptcha() async {
    captchaModel.data = null;
    Map<String, dynamic>? response = await ApiHelper().apiGetCaptcha();
    // HelperMethod().customPrint("check data ${response.toString()}");
    if (response != null) {
      captchaModel = CaptchaModel.fromJson(response);
      notifyListeners();
      // Fluttertoast.showToast(msg: "Login Suc...........");
    }
  }

  updateOtpPasswordStatus({required bool status, bool state = true}) {
    isOtpPasswordStatus = status;
    if (state) {
      notifyListeners();
    }
  }

  void resetSignUpValidations() {
    passwordValidState.password = "";
    notifyListeners();
  }

  resendButtonForOtpLoginFun() {
    enableResendButtonForLoginOtp = !enableResendButtonForLoginOtp;
    notifyListeners();
  }

  updateVisibleOtp() {
    otpValidationVisible = true;
    notifyListeners();
  }

  updatePinStatus(String pin) {
    completedPin = pin;
    notifyListeners();
  }

  enableResendOtpButtonLoginFun() async {
    enableResendButtonForLoginOtp = !enableResendButtonForLoginOtp;
    notifyListeners();
  }

  enableResendOtpButtonForgotPasswordFun() async {
    enableResendButtonForgotPassword = !enableResendButtonForgotPassword;
    notifyListeners();
  }

  updatePasswordSignIn() {
    passObsureSignIn = !passObsureSignIn;
    notifyListeners();
  }

  updatePasswordSignup() {
    passObsureSignUp = !passObsureSignUp;
    notifyListeners();
  }

  updateConfirmPassword() {
    confirmPassObsureSignUp = !confirmPassObsureSignUp;
    notifyListeners();
  }

  updateNewPasswordChangePwd() {
    passObsureChangePwd = !passObsureChangePwd;
    notifyListeners();
  }

  updateConfirmPasswordInChangePwd() {
    confirmPassObsureChangePwd = !confirmPassObsureChangePwd;
    notifyListeners();
  }

  void clearAuthProviderState() {
    isOtpRequestLoading = false;
    isOtpValidingLoading = false;
    isChangePasswordLoading = false;
    isOtpRequestLoding = false;
    isOtpPasswordStatus = false;
    resendButtonForOtpLogin = false;
    otpValidationVisible = false;
    completedPin = "";
    passObsureSignIn = false;
    passObsureSignUp = false;
    confirmPassObsureSignUp = false;
    passObsureChangePwd = false;
    confirmPassObsureChangePwd = false;
    enableResendButtonForLoginOtp = false;
    enableResendButtonForgotPassword = false;
    enableConfirmPasswordFeild = false;
    notifyListeners();
  }

  enableConfirmPasswordFeildFun(String? value) {
    value == null || value == ""
        ? enableConfirmPasswordFeild = true
        : enableConfirmPasswordFeild = false;

    notifyListeners();
  }

  ////Get profile API
  Future<void> getProfile() async {
    try {
      var response = await getProfileApi.getProfile();
      if (response.statusCode == 200) {
        profileData = response;
        notifyListeners();
      }
    } on DioException catch (e) {
      debugPrint("the dio error profile ${e.error} && ${e.response}");
    } catch (e, st) {
      debugPrint("API Error ${e.toString()}");
      debugPrint("API Error ${st.toString()}");
    }
  }

  ////Get profile API

  Future<void> getFaq() async {
    isLoading = true;
    try {
      var response = await getFaQApi.getFAQ();

      isLoading = false;
      print("dfnsdfsgfj ${response['data']['faqList']}");
      // FaqModel? faqData = response.data['data']['faqList'];
      List faqData = response['data']['faqList'];
      faqsList = faqData.map((e) => FaqList.fromJson(e)).toList();
      finalUpdatedFaqList = faqsList;
      notifyListeners();
    } on DioException catch (e) {
      print("dfnsdfsgfj ${e.response.toString()}");
      CustomToast.showErrorToast(msg: e.message.toString());
    } catch (e) {
      print("dfnsdfsgfj ${e.toString()}");
      isLoading = false;
      print(e);
    }
  }

  void localSearchForFaq(String searchedText) {
    print(searchedText);
    finalUpdatedFaqList = [];
    if (searchedText.length > 2) {
      finalUpdatedFaqList.addAll(faqsList
          .where((element) => element.questions!
              .toLowerCase()
              .toString()
              .contains(searchedText.toLowerCase()))
          .toList());
      notifyListeners();
      return;
    }
    if (searchedText.isEmpty) {
      finalUpdatedFaqList = faqsList;
      notifyListeners();
      return;
    }
    if (searchedText.isNotEmpty) {
      finalUpdatedFaqList = faqsList;
      notifyListeners();
      return;
    }
  }

  void passwordValidator(String password, bool showPasswordInfo) {
    bool atLeastOneUpperCase = RegExp(r'''([A-Z])''').hasMatch(password);
    bool atLeastOneLowerCase = RegExp(r'''([a-z])''').hasMatch(password);
    bool atLeastOneDigit = RegExp(r"([0-9])").hasMatch(password);
    bool atLeastOneSpecialCharecter =
        RegExp(r'''[?=.*?[!@#\$&*_~]''').hasMatch(password);
    bool atLeast8Charecters = RegExp('''(.{8,})''').hasMatch(password);
    passwordValidState = ValidatePassWord(
      isLowerCaseExists: atLeastOneLowerCase,
      isNumberExists: atLeastOneDigit,
      isSpecialCharacterExists: atLeastOneSpecialCharecter,
      isUpperCaseExists: atLeastOneUpperCase,
      is8Characters: atLeast8Charecters,
      isValidPassWord: atLeastOneLowerCase &&
          atLeastOneDigit &&
          atLeastOneSpecialCharecter &&
          atLeast8Charecters &&
          atLeastOneUpperCase,
      password: password,
      showPassWordInfo: showPasswordInfo,
    );
    notifyListeners();
  }

  ///Login with password
  Future<void> loginUser(String email, String password, BuildContext context,
      WebinarProvider provider) async {
    Loading.indicator(context);
    notifyListeners();
    String encryptedMail =
        EncryptionHelper.encrypt(email + BaseUrls.oMailEndTag);
    String encryptedPass = EncryptionHelper.encrypt(password);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      "emailId": encryptedMail,
      "password": encryptedPass,
    };
    try {
      final response = await apiRepository.loginUser(data);
      if (response.statusCode == 200) {
        // provider.requestPermission(AppPermissions.home);

        await serviceLocator<UserCacheService>()
            .saveToken(response.data!["accessToken"]);
        apiHelper.updateAuthorization().then((value) async {
          try {
            final res = await getProfileApi.getProfile();
            await sharedPreferences.setString(
                "saveProfileData", jsonEncode(res.data!.toJson()));
            profileData = res;
            if (res.statusCode == 200) {
              updateOConnectTokenFun(
                  context: context,
                  oesToken: response.data!["accessToken"],
                  statusMag: "Login Successfully");
              // String customerId = profileData!.data!.customerAccounts!.first.custAffId.toString();

              // final resp = await oesRequest.checkSubscribedProducts(customerId);
              // UserSubscriptionModel? userSubscriptionModel = resp;

              // if (userSubscriptionModel.body == null || userSubscriptionModel.body!.isEmpty) {
              //   if (context.mounted) {
              //     Navigator.pop(context);
              //     showDialog(
              //         context: context,
              //         builder: (context) => const CheckSubscriptionPopUp(
              //               fromLogin: true,
              //             ));
              //   }
              //   return;
              // } else {
              //   if (context.mounted) {
              //     updateOConnectTokenFun(context: context, oesToken: response.data!["accessToken"], statusMag: "Login Successfully");
              //   }
              // }
            }
          } on DioException catch (e, st) {
            if (e.response!.statusCode == 500) {
              CustomToast.showErrorToast(msg: "Something went wrong");
              return;
            }
            debugPrint("the profile dio error is the ${e.toString()} && $st");
            CustomToast.showErrorToast(msg: e.message.toString());
          } catch (e, st) {
            Navigator.pop(context);
            debugPrint("the profile error is the ${e.toString()} && $st");
          }
        });

        notifyListeners();
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          CustomToast.showErrorToast(msg: response.message);
        }
        notifyListeners();
      }
    } on DioException catch (e, st) {
      print("the error is the ${e.error} $st");

      if (e.response == null) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: "Something went wrong");
        return;
      } else if (e.response!.statusCode == 500) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: "Something went wrong");
        return;
      } else if (context.mounted) {
        print("the error is the ${e.response!.data.toString()} $st");
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: e.response!.data["message"]);
      } else {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: "Something went wrong");
        return;
      }
    } catch (e) {
      print("the catched error ${e.toString()}");
      if (context.mounted) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: "Error while login $e");
      }
      notifyListeners();
    }
  }

  Future<void> sendOtpRequestLogin(
      String alternateEmailId, BuildContext context,
      {bool isFromResendButton = false}) async {
    Loading.indicator(context);

    try {
      final response =
          await apiRepository.sendOtpRequestLogin(alternateEmailId);
      if (response.statusCode == 200) {
        if (context.mounted) {
          if (isFromResendButton) {
            resendButtonForOtpLoginFun();
          }

          Navigator.pop(context);
          CustomToast.showSuccessToast(msg: response.message);
          if (!isFromResendButton) {
            Navigator.pushNamed(
              context,
              RoutesManager.loginOtpScreen,
              arguments: alternateEmailId,
            );
          }
        }
        notifyListeners();
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          CustomToast.showErrorToast(msg: response.message);
        }
        notifyListeners();
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 500) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: "Something went wrong");
        return;
      }
      if (context.mounted) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: "Email ID is incorrecct");
      }
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: "Error while sending otp");
      }
    }
  }

  Future<bool> checkIfUserLoggedIn() async {
    final token = await serviceLocator<UserCacheService>().getOConnectToken();
    if (token != null && token.isNotEmpty) {
      // serviceLocator<Request>().updateAuthorization(token);
      apiHelper.updateAuthorization();
    }
    return token != null && token.isNotEmpty;
  }

  Future<void> registerUser(
      Map<String, dynamic> data, BuildContext context) async {
    Loading.indicator(context);
    notifyListeners();
    try {
      suggestionsUserNamesList = [];
      final response = await apiRepository.registerUser(data);
      if (response.statusCode == 200) {
        // provider.requestPermission(AppPermissions.home);
        await serviceLocator<UserCacheService>()
            .saveToken(response.data!["accessToken"]);
        apiHelper.updateAuthorization().then((value) async {
          final res = await getProfileApi.getProfile();
          profileData = res;
          if (res.statusCode == 200) {
            String customerId =
                profileData!.data!.customerAccounts!.first.custAffId.toString();

            final resp = await oesRequest.checkSubscribedProducts(customerId);
            UserSubscriptionModel? userSubscriptionModel = resp;

            if (userSubscriptionModel.body == null ||
                userSubscriptionModel.body!.isEmpty) {
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                CustomToast.showSuccessToast(msg: "Register Successfully");
                showDialog(
                    context: context,
                    builder: (context) => const CheckSubscriptionPopUp(
                          fromLogin: true,
                        ));
              }
              return;
            } else {
              if (context.mounted) {
                updateOConnectTokenFun(
                    context: context,
                    oesToken: response.data!["accessToken"],
                    statusMag: "Register Successfully");
              }
            }
          }
        });
        notifyListeners();
      } else if (response.statusCode == 400) {
        apiGetCaptcha();
        if (context.mounted) {
          Navigator.pop(context);
          CustomToast.showErrorToast(msg: response.message);

          if (response.data.runtimeType == List) {
            for (var name in response.data) {
              suggestionsUserNamesList.add(name);
            }
            notifyListeners();
          }
        }
      }
    } on DioException catch (e) {
      apiGetCaptcha();
      if (e.response!.statusCode == 500) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: e.response!.data["message"]);
        return;
      }
      if (context.mounted) {
        Navigator.pop(context);
        if (e.response!.data["message"] == "INVALID_EMAIL") {
          CustomToast.showErrorToast(msg: "Please use a different mail id");
        } else {
          CustomToast.showErrorToast(msg: e.response!.data["message"] ?? "");
        }
        notifyListeners();
      }
    } catch (e, st) {
      apiGetCaptcha();
      if (context.mounted) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: "Ecosystem registration failed");
        notifyListeners();
      }
    }
  }

  Future<void> sendOtpRequestForForgotPassword(
      {required BuildContext context,
      required String alternateEmailId,
      bool isNavigationRequired = true}) async {
    Loading.indicator(context);
    notifyListeners();

    try {
      final response =
          await apiRepository.sendOtpRequestForForgotPassword(alternateEmailId);
      if (response.statusCode == 200) {
        enableResendButtonForgotPassword = false;
        if (context.mounted) {
          Navigator.pop(context);
          if (isNavigationRequired) {
            Navigator.pushNamed(context, RoutesManager.forgotpasswordOtpScreen,
                arguments: alternateEmailId);
          }

          CustomToast.showSuccessToast(msg: "OTP sent to your alternate mail");
          notifyListeners();
        }

        notifyListeners();
      } else {
        isOtpRequestLoading = false;
        if (context.mounted) {
          CustomToast.showErrorToast(msg: response.message);
        }
        notifyListeners();
      }
    } on DioException catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: e.response!.data["message"]);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: "Error while sending otp");
      }
      notifyListeners();
    }
  }

  Future<void> validateOtpForForgotPassword(
      {required String otp,
      required String alternateMail,
      bool isFromLoginOtp = false,
      required BuildContext context}) async {
    Loading.indicator(context);
    notifyListeners();
    try {
      final response =
          await apiRepository.validateOtpForForgotPassword(otp, alternateMail);
      if (isFromLoginOtp) {
        if (response.statusCode == 200) {
          // provider.requestPermission(AppPermissions.home);
          await serviceLocator<UserCacheService>()
              .saveToken(response.data!["accessToken"]);
          apiHelper.updateAuthorization().then((value) async {
            final res = await getProfileApi.getProfile();
            profileData = res;
            if (res.statusCode == 200) {
              String customerId = profileData!
                  .data!.customerAccounts!.first.custAffId
                  .toString();

              final resp = await oesRequest.checkSubscribedProducts(customerId);
              UserSubscriptionModel? userSubscriptionModel = resp;

              if (userSubscriptionModel.body == null ||
                  userSubscriptionModel.body!.isEmpty) {
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) => const CheckSubscriptionPopUp(
                            fromLogin: true,
                          ));
                }
                return;
              } else {
                if (context.mounted) {
                  updateOConnectTokenFun(
                      context: context,
                      oesToken: response.data!["accessToken"],
                      statusMag: "Login Successfully");
                }
              }
            }
          });

          notifyListeners();
        } else {
          if (context.mounted) {
            Navigator.pop(context);
            CustomToast.showErrorToast(msg: response.message);
          }
          notifyListeners();
        }
      } else {
        if (context.mounted) {
          Navigator.pushReplacementNamed(
            context,
            RoutesManager.changePasswordPage,
            arguments: {"emailId": alternateMail, "otp": otp},
          );
        }
      }
    } on DioException catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: e.response!.data["message"]);
      }
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: "Error while verify otp");
      }
      notifyListeners();
    }
  }

  Future<void> changeUserPassword(
      {required String password,
      required String alternateMailId,
      required BuildContext context}) async {
    Loading.indicator(context);
    notifyListeners();

    Map<String, dynamic> data = {
      "newPassword": password,
      "confirmPassword": password,
      "alternateEmailId": alternateMailId
    };

    try {
      final response = await apiRepository.changeUserPassword(data);
      print("the res data is the ${response.toJson()}");
      if (response.statusCode == 200) {
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
              context, RoutesManager.logIn, (route) => false);
          CustomToast.showSuccessToast(
              msg: "Password changed successfully, Please Log in");
        }
        print(
            "The status code is 200. The output is1111111111111111111111111111111111111111");
        notifyListeners();
      } else {
        if (context.mounted) {
          print(
              "The status code is 200. The output is 3333333333333333333333333333333333333333");
          Navigator.pop(context);
          // Navigator.pushNamedAndRemoveUntil(
          //     context, RoutesManager.logIn, (route) => false);
          CustomToast.showErrorToast(msg: response.message);
        }
        print(
            "The status code is 200. The output is2222222222222222222222222222222");
        notifyListeners();
      }
    } on DioException catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: e.response!.data["message"]);
        print("The status code is 200. The output 444444444444444");
      }
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: "Error while changing password");
      }
      notifyListeners();
    }
  }

  Future<void> validateForgotPasswordOtp(
      {required String alternateEmailId,
      required String otp,
      required BuildContext context}) async {
    try {
      final response =
          await apiRepository.validateForgotPasswordOtp(alternateEmailId, otp);
      print("the response is the ${response.toJson()}");
      if (response.statusCode == 200) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(
              context, RoutesManager.changePasswordPage,
              arguments: {"emailId": alternateEmailId});
        }
      }
    } on DioException catch (e) {
      print("the error is the ${e.response}");
      if (context.mounted) {
        CustomToast.showErrorToast(msg: e.response!.data["message"]);
      }
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        CustomToast.showErrorToast(msg: "Error while changing password");
      }
      notifyListeners();
    }
  }

  Future<void> updateOConnectTokenFun(
      {required BuildContext context,
      required String oesToken,
      required String statusMag}) async {
    try {
      Map<String, dynamic> oConnectAuthHeader = {
        "Authorization": oesToken,
        "application": "oes"
      };

      final oConnectresponse =
          await oConnectAuthRequest.generateRandomToken(oConnectAuthHeader);
      tempRandomToken = oConnectresponse.data!.tokenKey;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          getOConnectToken(context, tempRandomToken!, oesToken, statusMag);
        }
      });
    } on DioException catch (e) {
      if (e.response!.statusCode == 500) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: "Something went wrong");
        return;
      }
      if (context.mounted) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: e.message);
      }
    } catch (e) {
      Navigator.pop(context);
      debugPrint("the catched error ${e.toString()}");
    }
  }

  void getOConnectToken(BuildContext context, String tempRandomTokens,
      String oesToken, String statusMsg) async {
    try {
      Map<String, dynamic> header = {"AuthorizationObs": oesToken};
      Map<String, dynamic> bodyData = {"tokenKey": tempRandomTokens};
      var res = await oConnectAuthRequest.generateRandomOConnectToken(
          header, bodyData);

      await serviceLocator<UserCacheService>().saveToken(oesToken);
      await serviceLocator<UserCacheService>()
          .saveOConnectToken(res.data!.accessToken!);
      await serviceLocator<UserCacheService>()
          .saveOConnectRefressToken(res.data!.refreshToken!);
      await serviceLocator<UserCacheService>()
          .saveUserData("userData", jsonEncode(res.data!.user!.toJson()));
      debugPrint("the refress token is the ${res.data!.refreshToken!}");
      if (context.mounted) {
        // Provider.of<WebinarProvider>(context, listen: false)
        //     .requestPermission(AppPermissions.home);
        Navigator.pop(context);
        context.read<HomeScreenProvider>().updateCurrentPage(0);
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesManager.homeScreen, (route) => false);
        CustomToast.showSuccessToast(msg: statusMsg);
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 500) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: "Something went wrong");
        return;
      }
      if (context.mounted) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: e.message.toString());
      }
      debugPrint("the dio exception ${e.message}");
    } catch (e) {
      Navigator.pop(context);
      debugPrint("the catched error is the ${e.toString()}");
    }
  }
}
