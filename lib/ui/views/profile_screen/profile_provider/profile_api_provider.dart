import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_connect/core/encryption_helper.dart';
import 'package:o_connect/core/models/auth_models/generate_token_o_connect_model.dart';
import 'package:o_connect/core/models/dummy_models/dummy_model.dart';
import 'package:o_connect/core/models/response_models/profile_response_model.dart/profile_response_model.dart';
import 'package:o_connect/core/models/response_models/update_response_model.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/common_app_bar/FAQs.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/loading_helper/loading_indicator.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/authentication/terrms_and_policy/terms_n_conditions_privacy_policy.dart';
import 'package:o_connect/ui/views/profile_screen/get_profile_repoistory/get_profile_api_repo.dart';
import 'package:o_connect/ui/views/profile_screen/profile_model/profile_information_model.dart';
import 'package:o_connect/ui/views/profile_screen/profile_model/profile_menu_model.dart';
import 'package:o_connect/ui/views/profile_screen/referal_screen/referal_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreenProvider extends BaseProvider {
  bool ignoreImage = false;
  bool newPassword = false;
  bool currentPassword = false;

  bool confirmPassword = false;
  ValidatePassWord passwordValidState = ValidatePassWord();
  ProfileInfoData? profileInfoData;
  List<ProfileMenuModel>? profileMenuList;

  File? imageFile;
  GetProfileApi getProfileApi =
      GetProfileApi(ApiHelper().oesDio, baseUrl: BaseUrls.baseUrl);

  List<ProfileMenuModel> getProfileMeniList() {
    return List.of([
      ProfileMenuModel(
          icon: AppImages.userIdIcon, title: "ID: OES-5643", onTap: (() {})),
      ProfileMenuModel(
          icon: AppImages.language,
          title: "English",
          onTap: (() {
            CustomToast.showInfoToast(msg: "Coming Soon...");
          })),
      ProfileMenuModel(
          icon: AppImages.profileWalletIcon,
          title: "0K Credits",
          onTap: (() {})),
      ProfileMenuModel(
          icon: AppImages.profileLinkIcon,
          title: "Referal Link",
          iconData: Icons.chevron_right_outlined,
          onTap: (() {
            if (navigationKey.currentContext!
                    .read<AuthApiProvider>()
                    .profileData
                    ?.data
                    ?.isNdaSigned ??
                false) {
              Navigator.push(
                  navigationKey.currentContext!,
                  MaterialPageRoute(
                      builder: (context) => const ReferalScreen()));
            } else {
              CustomToast.showInfoToast(msg: "You're not affiliated");
            }
          })),
      ProfileMenuModel(
          icon: AppImages.faqIcon,
          title: "FAQs",
          onTap: (() {
            Navigator.push(navigationKey.currentContext!,
                MaterialPageRoute(builder: (context) => const FAQsPage()));
          })),
      ProfileMenuModel(
          icon: AppImages.profileTutorialIcon,
          title: "Tutorials",
          onTap: (() {
            CustomToast.showInfoToast(msg: "Coming Soon...");
          })),
    ]);
  }

  void newPasswordStatus() {
    newPassword = !newPassword;
    notifyListeners();
  }

  void resetValidationsSignUp() {
    passwordValidState.password = "";
    notifyListeners();
  }

  void currentPasswordStatus() {
    currentPassword = !currentPassword;
    notifyListeners();
  }

  void confirmPasswordStatus() {
    confirmPassword = !confirmPassword;
    notifyListeners();
  }

  Future<void> userData({File? profilePic}) async {
    var d = {
      "file": profilePic != null
          ? await MultipartFile.fromFile(
              profilePic.path,
              filename: profilePic.path.split('/').last,
              contentType: MediaType('image', 'png'),
            )
          : null,
    };
    if (ignoreImage) {
      d.remove('file');
    }
    FormData formData = FormData.fromMap(d);
    try {
      final response = await getProfileApi.updateUser(formData);
      if (response.statusCode == 200) {
        getProfileInfo();
      }
    } on DioException catch (e) {
      debugPrint("profilePicUploaded DioException $e");
    } catch (e) {
      debugPrint("profilePicUploaded In cache $e");
    }
    notifyListeners();
  }

  Future getProfileInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? userDataString =
        sharedPreferences.getString("saveProfileData");
    print(
        "Profile data is called ${sharedPreferences.getString("saveProfileData").toString()}");
    GetProfileResponsData? userData =
        GetProfileResponsData.fromJson(jsonDecode(userDataString!));
    // final String? userDataString = await serviceLocator<UserCacheService>().getUserData("userData");

    // GenerateTokenUser userData = GenerateTokenUser.fromJson(jsonDecode(userDataString!));
    try {
      print(
          "object profile data ${userData.customerAccounts!.first.custAffId.toString()} =+ ${userData.customerId.toString()} ");

      var response = await getProfileApi.getProfileInformationById(
          userData.customerAccounts!.first.custAffId.toString());

      if (response.statusCode == 200) {
        profileInfoData = response.data;
      }
    } on DioException catch (e) {
      debugPrint("the dio error  ${e.response}");
    } catch (e, st) {
      debugPrint("API Error ${e.toString()}");
      debugPrint("API Error ${st.toString()}");
    }
    notifyListeners();
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

  bool isPicEdit = false;

  updateImagePickerFile(XFile image) {
    imageFile = File(image.path);
    isPicEdit = true;
    CustomToast.showSuccessToast(msg: "Profile pic updated successfully");
    notifyListeners();
  }

/*
  enableConfirmPasswordFeildFun(String? value) {
    value == null || value == "" ? enableConfirmPasswordFeild = true : enableConfirmPasswordFeild = false;

    notifyListeners();
  }
*/

/*  Future<void> userData({File? profilePic}) async {
    Map<String, dynamic> data = {"file": ""};
    var d = {
      "file": profilePic != null
          ? await MultipartFile.fromFile(
              profilePic.path,
              filename: profilePic.path.split('/').last,
              contentType: MediaType('image', 'png'),
            )
          : null,
    };
    if (ignoreImage) {
      d.remove('file');
    }
    FormData formData = FormData.fromMap(d);
    print("objectgffdeg");
    debugPrint("Form Data ==>> ${formData.toString()}");
    try {
      final response = await getProfileApi.updateUser(formData);
      print("cbcxfhbcdxfhdfxhfghf    ${response.status}");
    } on DioException catch (e, st) {
      print("object ${e.response.toString()} jhbgvbgbgjhbhj $st");
    } catch (e) {
      print("hghxghsdgd $e");
    }
  }*/

  Future<void> changePasswordProfile(
      {required String password,
      required String oldPassword,
      required BuildContext context}) async {
    String encryptedPass = EncryptionHelper.encrypt(password);
    String encryptedOldPass = EncryptionHelper.encrypt(oldPassword);
    Map<String, dynamic> data = {
      "newPassword": encryptedPass,
      "confirmPassword": encryptedPass,
      "oldPassword": encryptedOldPass,
    };
    try {
      Loading.indicator(context);
      final response = await getProfileApi.changePassword(data);
      if (response.statusCode == 200) {
        print("sdjdhjgh ${response.data}");

        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
          CustomToast.showSuccessToast(msg: "Password changed successfully");
        }
      }
    } on DioException catch (e) {
      CustomToast.showErrorToast(msg: e.response!.data["message"])
          .then((value) {
        Navigator.pop(context);
      });
    } catch (e) {
      debugPrint("Catch in Change password Profile ${e.toString()}");
      if (context.mounted) {
        CustomToast.showErrorToast(msg: e.toString()).then((value) {
          Navigator.pop(context);
        });
      }
    }
    notifyListeners();
  }

  Future<void> updateProfile(
      {required String firstName,
      required String lastName,
      required String alternateEmailId,
      required String mobileNumber,
      required BuildContext context,
      required String countryCode}) async {
    Loading.indicator(context);

    Map<String, dynamic> data = {
      "alternateEmail": alternateEmailId,
      "countryCode": countryCode,
      "firstName": firstName,
      "lastName": lastName,
      "mobileNumber": mobileNumber,
      "nationality": "India"
    };
    try {
      UpdateResponseModel? response;
      if (isPicEdit) {
        await userData(profilePic: imageFile);
        response = await getProfileApi.updateProfile(data);
      } else {
        response = await getProfileApi.updateProfile(data);
      }

      if (response?.statusCode == 200) {
        Navigator.pop(navigationKey.currentState!.context);
        Navigator.pop(navigationKey.currentState!.context);
        CustomToast.showSuccessToast(
            msg: "Profile details updated successfully.");
        context.read<ProfileScreenProvider>().getProfileInfo();
      }
    } on DioException catch (e) {
      Navigator.pop(navigationKey.currentState!.context);
      Navigator.pop(navigationKey.currentState!.context);
      debugPrint("Update profile DioException ${e.response.toString()}");
    } catch (e) {
      Navigator.pop(navigationKey.currentState!.context);
      Navigator.pop(navigationKey.currentState!.context);
      debugPrint("Update profile cache exception ${e.toString()}");
    }

    notifyListeners();
  }

  Future<void> deleteProfilePic() async {
    try {
      final response = await getProfileApi.deleteProfilePic();
      print(response);
      if (response.statusCode == 200) {
        CustomToast.showSuccessToast(msg: "Profile pic deleted successfully.");
        getProfileInfo();
      }
    } on DioException catch (e) {
      debugPrint(
          "Update profile DioException ${e.response.toString()}  ${e.error}");
    } catch (e) {
      debugPrint("delete profile pic ${e.toString()}");
    }
    notifyListeners();
  }
}
