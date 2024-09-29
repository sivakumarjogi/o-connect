import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/loading_helper/loading_indicator.dart';
import '../../ui/utils/base_urls.dart';
import '../models/countries_models.dart';
import '../models/get_all_state_model.dart';
import '../models/response_models/get_all_groups_response_model/get_group_details_by_group_id_response_model.dart';
import '../repository/auth_repository/auth_api_repo.dart';
import '../service/api_helper/api_helper.dart';

class CreateContactProvider extends ChangeNotifier {
  AuthApiRepository apiRepository = AuthApiRepository(ApiHelper().oesDio, baseUrl: BaseUrls.baseUrl);
  File? imageFile;
  List<GetCountries> countriesList = [];
  List<GetAllStateModel> statesList = [];
  List stateIdsList = [];
  String selectedCountry = "";
  String selectedState = "";
  String countryId = "";
  int? stateId;
  String countryCode = "";
  String countryIso = "";
  int? selectedCountryId;
  String? suggestedContactProfile;
  String? editContactPic;

  /// Update DropDown Value
  void updateDropdownValue({
    required String countryName,
  }) async {
    selectedCountry = countryName;
    for (var countryData in countriesList) {
      if (countryData.name == countryName) {
        countryCode = countryData.phoneCode;
        countryCode = countryData.phoneCode.toString();
        countryIso = countryData.iso2.toString();
        countryId = countryData.id.toString();
      }
    }
    if (selectedCountry != "Select Country") {
      getAllStates(countryId);
    } else {
      selectedState = "";
      statesList.clear();
    }
    notifyListeners();
  }

  set changeCountry(
    String country,
  ) {
    selectedCountry = country;
  }

  updateImagePickerFile(XFile image) {
    imageFile = File(image.path);
    notifyListeners();
  }

  /// Updating State Value
  updateStateValue({required String updatedValue, bool isInitState = false}) {
    selectedState = updatedValue;
    if (!isInitState) {
      if (updatedValue != "Select State") {
        for (var item in statesList) {
          if (item.name == updatedValue) {
            stateId = item.id;
            print("the state id $stateId");
          }
        }
      }
      notifyListeners();
    }
  }

  clearTempImage({bool isEdit = false}) {
    imageFile = null;
    selectedCountry = "";
    statesList.clear();
    suggestedContactProfile = null;
  }

  /// Create Contact API Call
  Future<void> createContact({
    required Map data,
    required File? contactPic,
    String? dbContact,
    bool ignoreImage = false,
    bool isEdit = false,
    required BuildContext context,
  }) async {
    var d = {
      "file": contactPic != null
          ? await MultipartFile.fromFile(
              contactPic.path,
              filename: contactPic.path.split('/').last,
              contentType: MediaType('image', 'png'),
            )
          : null,
      'contact': MultipartFile.fromString(
        jsonEncode(data),
        contentType: MediaType.parse('application/json'),
      ),
    };

    if (ignoreImage) {
      d.remove('file');
    }

    FormData formData = FormData.fromMap(d);
    print("the send data is the $stateId && ${formData.fields}");
    try {
      Loading.indicator(context);
      final response = await apiRepository.createContact(formData);
      if (response.statusCode == 200) {
        if (context.mounted) {
          imageFile = null;
          statesList = [];
          CustomToast.showSuccessToast(
            msg: isEdit == false ? "Contact created successfully" : "Contact updated successfully",
          ).then((value) {
            Navigator.pop(context);
            Navigator.pop(context, true);

            // Navigator.pushNamedAndRemoveUntil(context, RoutesManager.allContacts, (route) => false);
            updateDropdownValue(countryName: "");
          });
        }
      }
    } on DioException catch (e) {
      Navigator.pop(context);
      if (e.response!.statusCode == 400) {
        CustomToast.showErrorToast(msg: e.response!.data["message"]);
      }

      debugPrint(e.response.toString());
    } catch (e, st) {
      Navigator.pop(context);
      debugPrint("${e.toString()} && stack strace $st");
    }
  }

  /// Get Countries API Call
  Future<void> getCountries({String? countryCode, bool isEdit = false, bool isFromInitState = false}) async {
    final response = await apiRepository.getCountries();
    countriesList = (response.data["body"] as List).map((e) => GetCountries.fromJson(e)).toList();
    countryId = countriesList.where((element) => element.name == countriesList[0].name).first.id.toString();
    countryIso = countriesList.where((element) => element.name == countriesList[0].name).first.iso2.toString();

    if (isEdit) {
      getAllStates(countryCode ?? countriesList.first.id.toString(), isFromInitState: isFromInitState);
    }
    if (!isFromInitState) {
      notifyListeners();
    }
  }

  /// Get All States API Call
  Future getAllStates(String selectedCountryCode, {bool isFromInitState = false}) async {
    final response = await apiRepository.getAllStates(selectedCountryCode);
    statesList = (response.data["body"] as List).map((e) => GetAllStateModel.fromJson(e)).toList();
    if (statesList.isNotEmpty) {
      selectedState = "Select State";
    }
    if (!isFromInitState) {
      notifyListeners();
    }
  }

  Future<Contact?> getEmailSuggestions(String emailId) async {
    try {
      Response suggestionsResponse = await ApiHelper().oesDio.get("${BaseUrls.baseUrl}/alternateEmailId/$emailId");
      log(suggestionsResponse.data["data"].toString());
      if (suggestionsResponse.statusCode == 200 && suggestionsResponse.data["data"] != null) {
        Contact contact = Contact.fromJson(suggestionsResponse.data["data"]);
        selectedState = contact.stateName ?? "";
        imageFile = null;
        suggestedContactProfile = contact.contactPic ?? "";
        notifyListeners();
        return contact;
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}
