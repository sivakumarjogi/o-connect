import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:o_connect/core/models/create_webinar_model/contact_groups_model/create_webinar_all_contacts.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/provider/create_webinar_provider.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/loading_helper/loading_indicator.dart';
import 'package:o_connect/ui/views/invite/inivtes_repo/invites_repo.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:provider/provider.dart';

class InvitePopupProvider extends BaseProvider with MeetingUtilsMixin {
  InvitesRepo invitesRepo = InvitesRepo(ApiHelper().oConnectDio, baseUrl: BaseUrls.meetingBaseUrl);

  List<String> invitesList = [];

  List<String> inviteContactsList = [];
  List<int> contactsEmailIndex = [];
  List<AllContactsResponseModelBody> contactsList = [];
  List<AllContactsResponseModelBody> get finalContactList => contactsList.where((element) => element.show ?? true).toList();

  initCall() {
    Provider.of<CreateWebinarProvider>(context, listen: false).fetchAllContacts().then((value) {
      contactsList = Provider.of<CreateWebinarProvider>(context, listen: false).getAllContactsBody;
      notifyListeners();
    });
  }

  void searchContacts(String searchText) async {
    if (searchText.isEmpty) {
      contactsList = contactsList.map((e) => e.copyWith(show: true)).toList();
      notifyListeners();
      return;
    }
    contactsList = contactsList.map((e) {
      return e.copyWith(show: e.firstName!.toString().toLowerCase().contains(searchText) || e.alternateEmailId!.toString().toLowerCase().contains(searchText));
    }).toList();
    notifyListeners();
  }

  void addEmailToInvite(String email) {
    invitesList.add(email);
    notifyListeners();
  }

  addContactsEmailToInviteList(String contactEmail, int index) {
    inviteContactsList.add(contactEmail);
    contactsEmailIndex.add(index);
    notifyListeners();
  }

  removeContactsEmailsFromInviteList(int index) {
    inviteContactsList.removeAt(index);
    contactsEmailIndex.remove(index);
    notifyListeners();
  }

  removeEmailsFromInviteList(int index) {
    invitesList.removeAt(index);
    notifyListeners();
  }

  clearData() {
    invitesList.clear();
    inviteContactsList.clear();
    contactsEmailIndex.clear();
  }

  Future<void> sendInvitesToEmail(BuildContext context) async {
    final userData = context.read<ParticipantsProvider>().myHubInfo;
    Loading.indicator(context);
    List inviteEmailsList = [];
    List inviteContacts = [];

    print("the contacts list $inviteContactsList && $invitesList");
    if (inviteContactsList.isNotEmpty) {
      for (var email in inviteContactsList) {
        inviteContacts.add({"email": email, "type": "new", "roleId": 5, "role": 5, "contactFlag": 1});
      }
    }

    if (invitesList.isNotEmpty) {
      for (var email in invitesList) {
        inviteEmailsList.add({"email": email, "type": "new", "roleId": 5, "role": 5, "contactFlag": 1});
      }
    }

    try {
      final payLoad = {
        //TODO: add meeting id
        "meeting_id": meeting.id,
        "contacts": inviteContacts.isNotEmpty ? inviteContacts : [],
        "emails": inviteEmailsList.isNotEmpty ? inviteEmailsList : "",
        "groups": [],
        "userInfo": {"userName": userData.email, "userEmai": userData.email, "name": userData.displayName}
      };

      final res = await invitesRepo.sendInvite(payLoad);
      print("the response is the ${res.data}");
      if (res.data["status"]) {
        clearData();

        CustomToast.showSuccessToast(msg: res.data["data"]).then((_) {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      }

      /* final response = await invitesRepo.sendInvite(emailList: invitesList, contactList: inviteContactsList);*/
    } on DioException catch (e) {
      debugPrint("error dio exception for invite ${e.response.toString()}");
      if (e.response!.statusCode == 500) {
        Navigator.pop(context);
        CustomToast.showErrorToast(msg: "Something went wrong");
      }

      CustomToast.showErrorToast(msg: "Error while invite").then((value) {
        Navigator.pop(context);
      });
      /* Navigator.pop(context);
      CustomToast.showErrorToast(msg: e.response!.data["error"]);*/
    } catch (e, st) {
      Navigator.pop(context);
      CustomToast.showErrorToast(msg: "Something went wrong");
      debugPrint("error dio exception for invite ${e.toString()} $st");
    }

    /*response.fold((failure) {
      Navigator.pop(context);
      print("the error $failure");
      CustomToast.showErrorToast(msg: failure);
    }, (data) {
      Navigator.pop(context);
      Navigator.pop(context);
      invitesList.clear();
      inviteContactsList.clear();
      contactsEmailIndex.clear();
      CustomToast.showSuccessToast(msg: data.data["data"]);
    });*/
  }

  callNotify() {
    notifyListeners();
  }
}
