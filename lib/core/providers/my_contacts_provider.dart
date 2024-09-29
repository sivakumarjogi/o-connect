import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_connect/core/models/countries_models.dart';
import 'package:o_connect/core/models/response_models/get_all_contacts_response_model/get_all_contacts_response_model.dart';
import 'package:o_connect/core/models/response_models/get_favorite_response_model/get_favorite_response_model.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/repository/auth_repository/auth_api_repo.dart';
import 'package:o_connect/core/repository/contacts_repository/contacts_api_repo.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/ui/utils/loading_helper/loading_indicator.dart';

import '../../ui/utils/base_urls.dart';
import '../../ui/utils/constant_strings.dart';
import '../../ui/utils/custom_toast_helper/custom_toast.dart';
import '../models/create_webinar_model/get_contact_model.dart';
import '../models/response_models/create_group_response_model/create_group_response_model.dart';
import '../models/response_models/get_all_groups_response_model/get_group_details_by_group_id_response_model.dart';
import '../service/download_files_service.dart';

class MyContactsProvider extends BaseProvider {
  AuthApiRepository apiRepository = AuthApiRepository(ApiHelper().oesDio, baseUrl: BaseUrls.baseUrl);

  /// Contacts API Repository
  ContactsAPIRepository contactsAPIRepository = ContactsAPIRepository(ApiHelper().oesDio, baseUrl: BaseUrls.baseUrl);

  TextEditingController contactSearchController = TextEditingController();

  List<GetCountries> countriesList = [];
  List<String> countriesCodeList = [];
  String selectedCountry = "";
  String? selectedCopuntryCode;
  int? selectedCountryId;
  TextEditingController callController = TextEditingController(text: "All Contacts");
  List<AllContactsModelDataRecord> contactsList = [];
  List<CreateGroupResponseModel> groupsContactsList = [];
  AllContactsModel? contactsModelData;
  TextEditingController dateOfBirthController = TextEditingController();
  List<int> favOrUnFav = [];
  bool status = true;
  bool isFavorite = false;
  int? isFavoriteAPICall;
  List<dynamic> groupsList = [];
  List<String> emailList = [];
  int selectedIndexValue = 0;
  bool deleteContactsLoading = false;
  bool contactsLoading = false;
  bool loadedMaxContacts = false;
  bool searchValue = false;

  List<AllContactsModelDataRecord> createGroupSearchedContacts = [];
  late Animation<double> animation;

  /// For Creating Group
  List selectedContactsList = [];
  List selectedContactsLocalList = [];
  List<Contact> groupContactList = [];
  List<dynamic> groupContactListId = [];
  int selectedDeleteTabValue = 1;
  List<int> selectedContactFromTrash = [];
  List<int> selectedGroupFromTrash = [];
  File? imageFileGroup;

  GetGroupsDetailsByGroupIdResponseModel? getGroupsDetailsByGroupIdResponseModel;

  /// Selected Index
  int selectedIndex = -1;
  List<DropdownMenuItem<String>>? countries;
  String selectedValue = ConstantsStrings.all;

  /// Removing Contact Value Edit List
  void updateGroupContactsValue({required int id}) {
    groupContactListId.remove(id);

    notifyListeners();
  }

  void addOrRemoveBoth({required int id}) {
    if (groupContactListId.contains(id)) {
      groupContactListId.remove(id);
    } else {
      groupContactListId.add(id);
    }
    notifyListeners();
  }

  void updatingValue(String date) {
    dateOfBirthController.text = date.substring(0, 10);
    notifyListeners();
  }

  void searchBoxEnableDisable() {
    searchValue = !searchValue;
    notifyListeners();
  }

  updateGroupImagePickerFile(XFile image) {
    imageFileGroup = File(image.path);
    notifyListeners();
  }

  clearFields() {
    imageFileGroup = null;
  }

  updateSelectedCategory(String value) {
    selectedValue = value;
    notifyListeners();
  }

  List<String> contactCategoriesItems = [
    ConstantsStrings.all,
    ConstantsStrings.ecoSystem,
    ConstantsStrings.oMail,
    ConstantsStrings.oConnect,
    ConstantsStrings.added,
  ];

  /// Update Contact List Trash
  void updateContactListTrash({required int contactId}) {
    if (selectedContactFromTrash.contains(contactId)) {
      selectedContactFromTrash.remove(contactId);
    } else {
      selectedContactFromTrash.add(contactId);
    }
    notifyListeners();
  }

  void getIndexData(context, index) {
    switch (index) {
      case 0:
        getAllContacts(context: context, index: index);
        break;
      case 1:
        getAllContacts(context: context, index: index);
        break;
      case 2:
        getGroups(context: context, index: index);
        break;
      case 3:
        getAllContacts(context: context, index: index);
        break;
      case 4:
        getGroups(context: context, index: index);
        break;
    }
  }

  void selectContactTypeData(context, index, val) {
    print("value ::: $val");
    switch (val) {
      case "All":
        getAllContacts(context: context, index: index, badgeId: "null");
        break;
      case "Ecosystem":
        getAllContacts(context: context, index: index, badgeId: "0");
        break;
      case "OMail":
        getAllContacts(context: context, index: index, badgeId: "2");
        break;
      case "Added":
        getAllContacts(context: context, index: index, badgeId: "0");
        break;
      case "OCONNECT":
        getAllContacts(context: context, index: index, badgeId: "4");
        break;
    }
    // notifyListeners();
  }

  /// Group List
  void updateGroupListTrash({required int groupId}) {
    if (selectedGroupFromTrash.contains(groupId)) {
      selectedGroupFromTrash.remove(groupId);
    } else {
      selectedGroupFromTrash.add(groupId);
    }
    notifyListeners();
  }

  /// Function for setting view by category values
  void settingControllerValue(String value) {
    callController.text = value;
    notifyListeners();
  }

  void updateIndexValue(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void updateSelectedIndexValue(int value) {
    selectedIndexValue = value;
    notifyListeners();
  }

  void updateSelectedDeleteTabValue(int value) {
    selectedDeleteTabValue = value;
    notifyListeners();
  }

  Future<void> getCountries() async {
    final response = await apiRepository.getCountries();
    countriesList = (response.data["body"] as List).map((e) => GetCountries.fromJson(e)).toList();
    debugPrint("Countries List ====>>>> $countriesList");
    countries = contactsList.cast<DropdownMenuItem<String>>();
    notifyListeners();
  }

  updataCountryInDropdown(String country, String countryCode, int countryId) {
    selectedCountry = country;
    selectedCopuntryCode = countryCode;
    selectedCountryId = countryId;
    notifyListeners();
  }

  Future<void> contactFilter(String searchText, {bool whileEdit = false}) async {
    createGroupSearchedContacts.clear();
    if (searchText.isEmpty) {
      createGroupSearchedContacts = [...contactsList];
      notifyListeners();

      return;
    }
    // selectedContactsList

    createGroupSearchedContacts = contactsList.where((getAllContact) {
      var isSelect = selectedContactsList.any((element) {
        return element.toString() == getAllContact.contactId.toString();
      });
      if (whileEdit) return getAllContact.firstName.toString().contains(searchText);

      if (!isSelect) {
        return getAllContact.firstName.toString().contains(searchText);
      } else {
        return true;
      }
    }).toList();
    print(createGroupSearchedContacts.length);
    notifyListeners();
  }

  Future<void> getAllContacts({required BuildContext context, int? isFavoriteAPICall, int? isTrashAPICall, String? badgeId, String? searchKey, int? index, int pageNumber = 0}) async {
    Map<String, dynamic> data = {
      "pageNumber": 0,
      "pageSize": 100,
      "sortOrder": "",
      "searchKey": searchKey ?? "",
      "badgeId": badgeId ?? "null",
      "favorite": index == 1 ? 1 : null,
      "trash": index == 3 ? 1 : 0,
    };
    try {
      contactsLoading = true;
      final response = await apiRepository.getAllContacts(data);
      if (response.statusCode == 200) {
        if (pageNumber == 0) {
          contactsList = response.data!.records ?? [];
        } else {
          if (response.data!.records!.isNotEmpty) {
            contactsList.addAll(response.data!.records!);
            if (response.data!.records!.length < 10) {
              loadedMaxContacts = true;
            }
          }
        }
      }
      debugPrint("the contacts length ${contactsList.length}");
    } on DioException catch (e) {
      debugPrint("View Group catch Dio ${e.toString()}");
    } catch (e) {
      debugPrint("View Group catch  ${e.toString()}");
    }
    contactsLoading = false;
    notifyListeners();
  }

  Future getGroups({required BuildContext context, int? trashStatus, String? searchKey, int? index}) async {
    Map<String, dynamic> data = {
      "pageNumber": 0,
      "pageSize": 100,
      "searchKey": searchKey ?? "",
      "trashStatus": index == 2 ? 0 : 1,
    };
    try {
      final response = await contactsAPIRepository.getAllGroups(data);
      debugPrint("groups response --- >>> ${response.toString()}");
      if (response["status"] == "Success") {
        List groupsData = response["data"]['records'];
        groupsContactsList = groupsData.map((e) => CreateGroupResponseModel.fromJson(e)).toList();
      } else {
        debugPrint("Error");
      }
    } on DioException catch (e) {
      print(e.message);
    } catch (e) {
      debugPrint("View Group catch  ${e.toString()}");
    }
    notifyListeners();
  }

  /// Delete Contacts API Calling and Sending Payload
  Future<GetAllContactsResponseModel?> deleteAllContacts({required BuildContext context, contactId, bool isViewContact = false, bool isFav = false, bool isFullScreenView = false}) async {
    deleteContactsLoading = true;
    notifyListeners();
    Map<String, dynamic> data = {
      "ids": [contactId]
    };
    print("printed data======>$data");
    try {
      final response = await apiRepository.deleteContacts(data);
      debugPrint("all contacts response here --- >>> ${response.data}");
      if (response.statusCode == 200) {
        if (context.mounted) {
          if (isViewContact) {
            if (isFav == true) {
              await getAllContacts(context: context, index: 1);
            } else {
              await getAllContacts(context: context, index: 0);
            }
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            await getAllContacts(context: context, index: 3);
            Navigator.pop(context);
          }
          if (isFullScreenView) {
            Navigator.pop(context);
          }
          CustomToast.showSuccessToast(msg: "${response.data['message']}");
        }
      }
      deleteContactsLoading = false;
    } on DioException catch (e) {
      deleteContactsLoading = false;
      CustomToast.showErrorToast(msg: e.message.toString());
      notifyListeners();
    } catch (e) {
      debugPrint("error while delete contact");
      deleteContactsLoading = false;
      notifyListeners();
    }
    notifyListeners();
    // final response = await apiRepository.deleteContacts(data);
    // debugPrint("all contacts response here --- >>> $response");
    // if (response.statusCode == 200) {
    //   debugPrint("Success");
    // } else {
    //   debugPrint("Failure");
    // }
    return null;
  }

  Future<GetFavoriteContacts?> getFavOrUnFav(BuildContext context, index, int? favStatus) async {
    Map<String, dynamic> data = {"ids": favOrUnFav};

    try {
      final response = await contactsAPIRepository.favOrUnFav(data);
      final getFavContacts = GetFavoriteContacts.fromJson(response);
      if (getFavContacts.statusCode == 200) {
        CustomToast.showSuccessToast(
            msg: (favStatus ?? 0) == 1 ? "Your contact is successfully removed from favourites" : "Your contact is successfully added to favourites" /*getFavContacts.message*/);
        if (context.mounted) {
          getAllContacts(context: context, index: index);
        }
        debugPrint("Success");
      } else {
        debugPrint("Failed");
      }
    } on DioException catch (e) {
      // print(e.response.toString());
      CustomToast.showErrorToast(msg: e.response?.statusMessage.toString());
    } catch (e) {
      // print(e.toString());
      CustomToast.showErrorToast(msg: "Something wrong...");
    }
    notifyListeners();
    return null;
  }

  /// Adding and removing
  void addOrRemoveValues(int a) {
    if (favOrUnFav == []) {
      debugPrint("Empty List");
    }
    if (favOrUnFav.contains(a)) {
      favOrUnFav.remove(a);
      debugPrint("favOrUnFav ====>>>>>>> $favOrUnFav");
      notifyListeners();

      /// API Call
      // getFavOrUnFav();
    } else {
      favOrUnFav.add(a);
      notifyListeners();

      /// API Call
      // getFavOrUnFav();
      debugPrint("favOrUnFav ====>>>>>>> $favOrUnFav");
    }
  }

  cancelSelectedContactValue() {
    print("khsksdhhksdsdkhsdiu2222222    ${selectedContactsLocalList.toString()}");

    // selectedContactsList = selectedContactsLocalList;
    notifyListeners();
  }

  /// Update Selected Contact Value for Group
  updateSelectedContactValue(contactId, name) {
    if (selectedContactsList.contains(contactId)) {
      selectedContactsList.remove(contactId);
      debugPrint("Value ===>>> $selectedContactsList");
      notifyListeners();
    } else {
      selectedContactsList.add(contactId);
      debugPrint("Value ===>>> $selectedContactsList");
      notifyListeners();
    }
  }

  /// Remove Value from contact list
  void removeSelectedContactFromGroupList({required int contactId}) {
    selectedContactsList.remove(contactId);
    notifyListeners();
  }

  void updateEmailList({required List<int> emailList}) {
    emailList = emailList;
    notifyListeners();
  }

  /// Create Group Function
  Future<void> createGroupFunction({context, required String name, required List<dynamic> ids, bool isFromEdit = false, required int id, File? contactPic, String? groupImageUrl}) async {
    Map data = {
      "groupId": id ?? 0,
      "groupName": name,
      "allEmailsData": ids,
      "toEmailsData": null,
    };

    if (groupImageUrl != null) {
      data.putIfAbsent('groupPic', () => groupImageUrl);
    }

    var groupPic = {
      "file": contactPic != null
          ? await MultipartFile.fromFile(
              contactPic.path,
              filename: contactPic.path.split('/').last,
              contentType: MediaType('image', 'png'),
            )
          : null,
      'groups': MultipartFile.fromString(
        jsonEncode(data),
        contentType: MediaType.parse('application/json'),
      ),
    };

    print(data.toString());
    FormData formData = FormData.fromMap(groupPic);
    try {
      final response = await contactsAPIRepository.createGroups(formData);
      debugPrint("Get All Contacts ===>>> ${response.toString()}");
      if (response["statusCode"] == 200) {
        debugPrint("Success");
        imageFileGroup = null;
        selectedContactsList.clear();
        getGroups(context: context, index: 2);
        if (isFromEdit) {
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
        CustomToast.showSuccessToast(msg: isFromEdit ? "Group Updated Successfully" : response["message"]);
      }
    } on DioException catch (e) {
      CustomToast.showErrorToast(msg: e.response.toString());
      debugPrint("Create Group DioException  ${e.response.toString()}");
    } catch (e) {
      debugPrint("Create Group catch  ${e.toString()}");
    }
    notifyListeners();
  }

  /// View Group Details API
  Future<void> viewGroupDetails({required BuildContext context, required int groupId}) async {
    selectedContactsList = [];
    try {
      debugPrint("View Group bY id response ==>> ");

      final response = await contactsAPIRepository.viewGroup(groupId);
      if (response.statusCode == 200) {
        getGroupsDetailsByGroupIdResponseModel = response;
        groupContactList = response.data.contacts;

        groupContactList.map((e) => {selectedContactsList.add(e.contactId)}).toList();
        print(selectedContactsList.toString());
        notifyListeners();
        debugPrint("List Here  =====>>> $groupContactListId");
      }
    } on DioException catch (e) {
      print(e.message);
    } catch (e) {
      debugPrint("View Group catch  ${e.toString()}");
    }
  }

  /// Delete Group
  Future<void> deleteGroup({groupId, required BuildContext context, required bool isViewGroup, bool isFullScreenView = false}) async {
    Map<String, dynamic> data = {
      "ids": isViewGroup ? [groupId] : groupId
    };

    try {
      deleteContactsLoading = true;
      notifyListeners();
      Response response = await contactsAPIRepository.deleteGroup(data);
      if (response.statusCode == 200) {
        selectedGroupFromTrash = [];

        if (isViewGroup) {
          getGroups(context: context, index: 2);
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          getGroups(context: context, index: 3);
          Navigator.pop(context);
        }
        deleteContactsLoading = false;
        notifyListeners();
        if (isFullScreenView) {
          Navigator.pop(context);
        }
        CustomToast.showSuccessToast(msg: response.data['message']);
      }
    } on DioException catch (e) {
      deleteContactsLoading = false;
      notifyListeners();
      print("error while restore or delete groups ${e.response.toString()}");
    } catch (e, st) {
      deleteContactsLoading = false;
      notifyListeners();
      debugPrint("View Group catch  ${e.toString()} && $st");
    }
    notifyListeners();
  }

  Future<void> uploadCSV(
    context,
    bool isFav,
    String? id,
  ) async {
    Map<String, dynamic> data = {"badgeId": id, "favorite": isFav ? 1 : null, "searchKey": "", "sortOrder": "", "trash": 0};
    String filePathCreate = await createFolder();
    String? oesTkn = await serviceLocator<UserCacheService>().getToken();
    print("ygiugbiublki879898778787456$data");
    try {
      Response response = await Dio().post(
        "${BaseUrls.baseUrl}/exportContactsToCSV",
        data: data,
        options: Options(
          headers: {"Authorization": 'Bearer $oesTkn'},
          responseType: ResponseType.bytes,
        ),
      );
      String filePath = '$filePathCreate/${DateTime.now().millisecondsSinceEpoch}.csv';

      File file = File(filePath);
      file.writeAsBytesSync(response.data);
      print("41111111111111111111111111111${response.data.toString()}");
      CustomToast.showSuccessToast(msg: "Downloaded successfully");
    } on DioException catch (e) {
      print(e.message);
      CustomToast.showErrorToast(msg: "Internal server error");
    } on Exception catch (e) {
      CustomToast.showErrorToast(msg: "Error while downloading");
    }

    notifyListeners();
  }

  /// Delete Group
  Future<void> permanentDeleteContacts({required BuildContext context, required bool isValue, bool isFromFullScreen = false}) async {
    Map<String, dynamic> data = {
      "ids": isValue ? [selectedContactFromTrash] : selectedContactFromTrash
    };
    debugPrint("Delete Permanent Contact Request ==>>> $data");
    try {
      deleteContactsLoading = true;
      notifyListeners();
      Response response = await contactsAPIRepository.permanentDeleteContact(data);

      if (response.statusCode == 200) {
        debugPrint("Success ${response.data}");
        if (response.data["status"] == "Success") {
          getAllContacts(context: context, index: 3);
          Navigator.pop(context);
          if (isFromFullScreen) {
            Navigator.pop(context);
          }
          CustomToast.showSuccessToast(msg: response.data['message']);
          debugPrint("Success ${response.data}");
        } else {
          deleteContactsLoading = false;
          Navigator.pop(context);
          CustomToast.showErrorToast(msg: "Error while deleting contact");
        }
      }
      deleteContactsLoading = false;
    } on DioException catch (e) {
      deleteContactsLoading = false;
      print("the error is the ${e.response}");
      Navigator.pop(context);
      CustomToast.showErrorToast(msg: e.response.toString());
    } catch (e, st) {
      deleteContactsLoading = false;
      Navigator.pop(context);
      CustomToast.showErrorToast(msg: "Error while deleting contact");
      debugPrint("View Group catch  ${e.toString()}  && $st");
    }
    selectedContactFromTrash = [];
    print("the list $selectedGroupFromTrash");
    notifyListeners();
  }

  /// Permanent Delete
  Future<void> permanentDeleteGroups({required BuildContext context, var selectedContactFromTrash, bool isFullScreenView = false}) async {
    Map<String, dynamic> data = {"ids": selectedGroupFromTrash};
    debugPrint("Delete Permanent Group Request ===>>>  $data");
    try {
      deleteContactsLoading = true;
      notifyListeners();
      Response response = await contactsAPIRepository.permanentDeleteGroup(data);
      debugPrint("View Group bY id response ==>> ${response.data}");
      if (response.statusCode == 200) {
        selectedGroupFromTrash = [];
        getGroups(context: context, index: 3);
        if (isFullScreenView) {
          Navigator.pop(context);
        }
        Navigator.pop(context);

        CustomToast.showSuccessToast(msg: response.data['message']);
      }
      deleteContactsLoading = false;
    } on DioException catch (e) {
      print(e.message);
      deleteContactsLoading = false;
    } catch (e) {
      debugPrint("View Group catch  ${e.toString()}");
      deleteContactsLoading = false;
    }
    notifyListeners();
  }

  /// Restore Contacts
  Future<void> restoreContacts({required BuildContext context}) async {
    debugPrint("Contacts Id list ====>>> $selectedContactFromTrash");
    Map<String, dynamic> data = {"ids": selectedContactFromTrash};
    debugPrint("Restore Contact Request ===>>> $data");
    try {
      Loading.indicator(context);
      final response = await contactsAPIRepository.restoreContact(data);
      Navigator.pop(context);
      debugPrint("Restore Contact bY id response ==>> ${response.data}");
      if (response.statusCode == 200) {
        debugPrint("Success");
      }
    } on DioException catch (e) {
      print(e.message);
    } catch (e) {
      debugPrint("Restore Contact catch  ${e.toString()}");
    }
  }

  /// Restore Groups
  Future<void> restoreGroups({required BuildContext context}) async {
    debugPrint("SSSSS ==> $selectedGroupFromTrash");
    Map<String, dynamic> data = {"ids": selectedGroupFromTrash};
    debugPrint("Restore Group Request   ===>>> $data");
    try {
      // Loading.indicator(context);
      final response = await contactsAPIRepository.deleteGroup(data);
      // Navigator.pop(context);
      debugPrint("Restore Group id response ==>> ${response.toString()}");
      if (response.statusCode == 200) {
        debugPrint("Success");
      }
    } on DioException catch (e) {
      debugPrint("Restore Group ===>>> ${e.message}");
    } catch (e) {
      debugPrint("Restore Group catch  ${e.toString()}");
    }
  }
}
