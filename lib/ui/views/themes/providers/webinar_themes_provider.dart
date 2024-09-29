import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/repository/get_all_sounds_repository/get_all_sounds_api_repo.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/themes/models/theme_color.dart';
import 'package:o_connect/ui/views/themes/models/webinar_themes_model.dart';

class WebinarThemesProviders extends BaseProvider with MeetingUtilsMixin {
  GetAllSoundsAPI getAllSoundsAPI = GetAllSoundsAPI(ApiHelper().oConnectDio, baseUrl: BaseUrls.bgmBaseUrl);
  List<WebinarThemesListModel>? themesDataModel = [];
  Color? themeBackGroundColor;
  Color? themeHighLighter;
  WebinarThemesListModel? selectedWebinarTheme;
  bool loadingThemes = false;

  /// Application colors
  Color bgColor = const Color(0xff16181A);
  Color headerNotchColor = const Color(0xff202223);
  Color selectButtonsColor = const Color(0xff0E78F9);
  Color unSelectButtonsColor = const Color(0xff292B2C);
  Color hintTextColor = const Color(0xff5E6272);
  Color closeButtonColor = const Color(0xff315D92).withOpacity(0.1);

  WebinarThemeColors? _colors;

  WebinarThemeColors get colors => _colors ?? WebinarThemeColors();

  void setupDefaultColors() {
    _colors = WebinarThemeColors(
      buttonColor: AppColors.mainBlueColor,
      calButtonColors: Theme.of(context).cardColor,
      headerColor: bgColor,
      itemColor: Theme.of(context).primaryColor,
      bodyColor: bgColor,
      cardColor: Theme.of(context).highlightColor,
      textColor: const Color(0xFF6C7BAD),
    );
  }

  Future<void> getThemes() async {
    try {
      loadingThemes = true;
      var response = await getAllSoundsAPI.getAllThemes();
      themesDataModel = [
        ...(response.data ?? []),
        ...[
          WebinarThemesListModel(fileName: "None"),
        ]
      ];
      loadingThemes = false;
    } on DioException catch (e) {
      loadingThemes = false;
      print("the error ${e.response}");
      CustomToast.showErrorToast(msg: e.message);
    } catch (e, st) {
      print("the error $st");
      loadingThemes = false;
      print("the webinar themes error is the $e");
    }
    notifyListeners();
  }

  void selectedThemeUpdate(WebinarThemesListModel theme) {
    selectedWebinarTheme = theme;
    notifyListeners();
  }

  updateSelectedTheme(WebinarThemesListModel theme) {
    selectedWebinarTheme = theme;
    // iconColor = Colors.pink;
    switch (theme.name) {
      case "Achievement 1":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF516CDE),
            headerColor: const Color(0xFF2047F4),
            itemColor: const Color(0xFF081C4C),
            bodyColor: const Color(0xFF1C336D),
            cardColor: const Color(0xFF081C4C),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Achievement 2":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF7B591E),
            headerColor: const Color(0xFFDC8606),
            itemColor: const Color(0xFF3D260B),
            bodyColor: const Color(0xFF1F1912),
            cardColor: const Color(0xFF3A2E1D),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Achievement 3":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF560053),
            headerColor: const Color(0xFFE335DD),
            itemColor: const Color(0xFF53085B),
            bodyColor: const Color(0xFF2B142C),
            cardColor: const Color(0xFF562257),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Achievement 4":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF1E0E4F),
            headerColor: const Color(0xFF4528BB),
            itemColor: const Color(0xFF11083D),
            bodyColor: const Color(0xFF171229),
            cardColor: const Color(0xFF281F50),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Achievement 5":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF3E1C86),
            headerColor: const Color(0xFF622BD4),
            itemColor: const Color(0xFF11083D),
            bodyColor: const Color(0xFF171229),
            cardColor: const Color(0xFF291F50),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Artificial Intelligence":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF3E49B8),
            headerColor: const Color(0xFF4253FF),
            itemColor: const Color(0xFF10165C),
            bodyColor: const Color(0xFF090C34),
            cardColor: const Color(0xFF0A116A),
            textColor: const Color(0xFFFFFFFF));
        break;

      case "Artificial Intelligence-2":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF034D39),
            headerColor: const Color(0xFF036842),
            itemColor: const Color(0xFF05342F),
            bodyColor: const Color(0xFF071F18),
            cardColor: const Color(0xFF053B2C),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Artificial Intelligence-3":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF16855D),
            headerColor: const Color(0xFF00B473),
            itemColor: const Color(0xFF04271B),
            bodyColor: const Color(0xFF071812),
            cardColor: const Color(0xFF052B1E),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Celebration 1":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF0C5689),
            headerColor: const Color(0xFF0E7ECC),
            itemColor: const Color(0xFF103C5C),
            bodyColor: const Color(0xFF0B2232),
            cardColor: const Color(0xFF0E4165),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Celebration 2":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF003030),
            headerColor: const Color(0xFF05B4B4),
            itemColor: const Color(0xFF001919),
            bodyColor: const Color(0xFF031E1E),
            cardColor: const Color(0xFF013A3A),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Celebration 3":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF6F0342),
            headerColor: const Color(0xFFDD0091),
            itemColor: const Color(0xFF300220),
            bodyColor: const Color(0xFF23091A),
            cardColor: const Color(0xFF430B2F),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Celebration 4":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF7B591E),
            headerColor: const Color(0xFFDC8606),
            itemColor: const Color(0xFF3A2E1D),
            bodyColor: const Color(0xFF1F1912),
            cardColor: const Color(0xFF3A2E1D),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Celebration 5":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF2B708C),
            headerColor: const Color(0xFF1BABE5),
            itemColor: const Color(0xFF133F50),
            bodyColor: const Color(0xFF0D2129),
            cardColor: const Color(0xFF123E50),
            textColor: const Color(0xFFFFFFFF));
        break;

      case "Condolence 1":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF7D5E8C),
            headerColor: const Color(0xFF8406C2),
            itemColor: const Color(0xFF230633),
            bodyColor: const Color(0xFF1C0C25),
            cardColor: const Color(0xFF351147),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Condolence 2":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF262626),
            headerColor: const Color(0xFF706C6F),
            itemColor: const Color(0xFF2A2A2A),
            bodyColor: const Color(0xFF1D1D1D),
            cardColor: const Color(0xFF373737),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Condolence 3":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF57707D),
            headerColor: const Color(0xFF006D9B),
            itemColor: const Color(0xFF102027),
            bodyColor: const Color(0xFF1E2E36),
            cardColor: const Color(0xFF1C2E36),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Condolence 4":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF262626),
            headerColor: const Color(0xFF706C6F),
            itemColor: const Color(0xFF2B2B2B),
            bodyColor: const Color(0xFF3A3A3A),
            cardColor: const Color(0xFF3D3D3D),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "General 1":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF5557AF),
            headerColor: const Color(0xFF3A35FF),
            itemColor: const Color(0xFF0F1E2E),
            bodyColor: const Color(0xFF0B1431),
            cardColor: const Color(0xFF132662),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "General 2":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF3F0E34),
            headerColor: const Color(0xFF950475),
            itemColor: const Color(0xFF191F2B),
            bodyColor: const Color(0xFF2B1827),
            cardColor: const Color(0xFF552D4D),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "General 3":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF08517D),
            headerColor: const Color(0xFF0088F0),
            itemColor: const Color(0xFF04304C),
            bodyColor: const Color(0xFF092435),
            cardColor: const Color(0xFF0B466B),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "General 4":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF18483D),
            headerColor: const Color(0xFF08AF89),
            itemColor: const Color(0xFF084436),
            bodyColor: const Color(0xFF0E2E26),
            cardColor: const Color(0xFF175B4B),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "General 5":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF1C3F87),
            headerColor: const Color(0xFF3265CC),
            itemColor: const Color(0xFF04112A),
            bodyColor: const Color(0xFF080D18),
            cardColor: const Color(0xFF07142C),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Space galaxy":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF3170DE),
            headerColor: const Color(0xFF0E62D7),
            itemColor: const Color(0xFF051330),
            bodyColor: const Color(0xFF0A1122),
            cardColor: const Color(0xFF0C1B41),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Space Black":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF333333),
            headerColor: const Color(0xFF000000),
            itemColor: const Color(0xFF1D1B1B),
            bodyColor: const Color(0xFF171717),
            cardColor: const Color(0xFF2A2828),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Pure Black":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF272727),
            headerColor: const Color(0xFF000000),
            itemColor: const Color(0xFF1D1C1C),
            bodyColor: const Color(0xFF2D2D2D),
            cardColor: const Color(0xFF303030),
            textColor: const Color(0xFFFFFFFF));
        break;
      case "Space Grey":
        _colors = WebinarThemeColors(
            buttonColor: const Color(0xFF4F5B66),
            headerColor: const Color(0xFF343D46),
            itemColor: const Color(0xFF848F99),
            bodyColor: const Color(0xFF30373C),
            cardColor: const Color(0xFF606D78),
            textColor: const Color(0xFFFFFFFF));
        break;
      default:
        _colors = WebinarThemeColors(
          buttonColor: AppColors.mainBlueColor,
          calButtonColors: Theme.of(context).cardColor,
          headerColor: Theme.of(context).scaffoldBackgroundColor,
          itemColor: Theme.of(context).primaryColor,
          bodyColor: Theme.of(context).scaffoldBackgroundColor,
          cardColor: Theme.of(context).highlightColor,
          textColor: const Color(0xFF6C7BAD),
        );
        break;
    }

    notifyListeners();
  }

  void emitNewTheme(WebinarThemesListModel theme) async {
    updateSelectedTheme(theme);
    var themeJson = theme.id != null ? theme.toJson() : {};

    await globalStatusRepo.updateGlobalAccessStatus({
      "key": "themes",
      "roomId": meeting.id,
      "value": themeJson,
    });

    hubSocket.socket?.emitWithAck(
      'onCommand',
      jsonEncode({
        "uid": "ALL",
        "data": {
          "command": "globalAccess",
          "type": "themes",
          "value": themeJson,
          "ou": userData.id,
        }
      }),
    );

    roomSocket.request(
      'moderator:applyThemes',
      {
        "theme": true,
        "roomId": meeting.id,
        "id": myHubInfo.peerId,
        "selectedTheme": themeJson,
      },
      (_) {},
      
    );
  }

  void resetData() {
    selectedWebinarTheme = null;
  }
}
