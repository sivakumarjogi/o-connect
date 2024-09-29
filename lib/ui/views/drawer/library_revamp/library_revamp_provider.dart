// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:o_connect/core/models/auth_models/generate_token_o_connect_model.dart';
import 'package:o_connect/core/repository/file_upload_repository/file_upload_repository.dart';
import 'package:o_connect/core/repository/library_repository/library_repo.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/core/service/download_files_service.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/common_app_bar/image_picker_bottombar.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/loading_helper/loading_indicator.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_files_model.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/widgets/folder_widget.dart';
import 'package:o_connect/ui/views/meeting/utils/get_svg_file_extension.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/presentation/provider/presentation_popup_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class LibraryRevampProvider extends ChangeNotifier with MeetingUtilsMixin {
  GenerateTokenUser? ocUserData;
  LibraryRepository libraryRepository = LibraryRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.libraryBaseUrl,
  );

  LibraryFilesModel libraryFilesModel = LibraryFilesModel(
    status: false,
    data: [],
  );

  LibraryFilesModel libraryFolderFilesModel = LibraryFilesModel(
    status: false,
    data: [],
  );
  bool searching = false;
  bool isSearchDataEmpty = false;
  String selectedFolderName = "";
  bool isDeleteSelection = false;
  List<LibraryItem> selectedLibraryItems = [];

  set setSelectedFolderName(String folderName) {
    selectedFolderName = folderName;
    notifyListeners();
  }

  bool get isFolderSelcted => selectedFolderName.isNotEmpty;

  Future<void> showPresentationFolderPopUp(
    BuildContext context,
    LibraryItem libraryItem,
  ) async {
    customShowDialog(
      context,
      FolderWidgetPage(
        folderName: libraryItem.folderName.toString(),
        fromPresentation: true,
      ),
      height: ScreenConfig.height * 0.7,
    );
  }

  Future<void> onItemTap({
    required LibraryItem libraryItem,
    required BuildContext context,
    bool toView = true,
    bool fromPresentation = false,
  }) async {
    if (libraryItem.isFolder) {
      if (fromPresentation) {
        showPresentationFolderPopUp(context, libraryItem);
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FolderWidgetPage(
            folderName: libraryItem.folderName.toString(),
          ),
        ),
      );

      // await CustomToast.showInfoToast(msg: "Coming soon....");
    } else {
      await fileDownloadLocal(
        name: libraryItem.fileName ?? "",
        url: libraryItem.readUrl ?? "",
        context: context,
        toView: toView,
      );
    }
  }

  Future<String> fileDownloadLocal({
    required String url,
    required String name,
    required BuildContext context,
    bool toView = true,
    bool? toast,
  }) async {
    Loading.indicator(context);
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    final getPath = await createFolder();
    var nameEnd = url.split(".").last;
    try {
      myUrl = url;
      print("the url is the $myUrl");
      var request = await httpClient.getUrl(Uri.parse(url));

      var response = await request.close();
      print(response);
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(
          response,
          onBytesReceived: (cumulative, total) {
            if (total != null) {}
          },
        );

        filePath = '$getPath/$name.$nameEnd';
        file = File(filePath);
        file.writeAsBytes(bytes);
        Navigator.pop(context);
        if (toView) {
          await OpenFile.open(filePath);
        } else {
          if (toast != null && toast) {
            Navigator.pop(context);
            await CustomToast.showDownloadToast(
              msg: "All Files Downloaded Successfully!",
              onTap: () async {
                await OpenFile.open(filePath);
              },
            );
          }
          if (toast == null) {
            await CustomToast.showDownloadToast(
              msg: "File Downloaded Successfully!",
              onTap: () async {
                await OpenFile.open(filePath);
              },
            );
          }
        }
      } else {
        await CustomToast.showErrorToast(msg: "File Download Failed..!");
        Navigator.pop(context);
      }
    } catch (ex, st) {
      print("the error $ex && $st");
      await CustomToast.showErrorToast(msg: "File Download Failed..!");
      Navigator.pop(context);
    }

    return filePath;
  }

  void resetState() {
    searching = false;
    isSearchDataEmpty = false;
    libraryFilesModel = LibraryFilesModel(
      status: false,
      data: [],
    );
    libraryFolderFilesModel = LibraryFilesModel(
      status: false,
      data: [],
    );
    // notifyListeners();
  }

  List<String> docExt = [
    "pdf",
    "txt",
    "doc",
    "docx",
    "xsl",
    "ppt",
    "xlsx",
    "pptx",
  ];
  List<String> audioExt = [
    "mp3",
    "wav",
    "ogg",
  ];
  List<String> videoExt = [
    "mp4",
    "avi",
    "mkv",
    "mov",
    "wmv",
    "flv",
    "webm",
    "3gp",
    "mpeg",
    "ogg",
  ];

  set setSearchStatus(bool status) {
    searching = status;
    notifyListeners();
  }

  List<LibraryItem> get libraryData => libraryFilesModel.data;

  List<LibraryItem> get presentationData => libraryFilesModel.data
      .where((element) => element.isPresentationItem)
      .toList();

  Future<void> getLibraryFilesData({
    required BuildContext context,
    bool fromMeetingRoom = false,
  }) async {
    // if (!fromMeetingRoom) {
    //   Loading.indicator(context);
    // }
    ocUserData ??= await getUserData();
    try {
      LibraryFilesModel res = await libraryRepository.fetchLibraryData(
        ocUserData?.id ?? 0,
        'presentation',
      );
      libraryFilesModel = res;
      log(res.data.length.toString());
      // if (!fromMeetingRoom) {
      //   Navigator.pop(context);
      // }
    } catch (e) {
      log("getLibraryFilesData Error -- $e");
    }

    notifyListeners();
  }

  Future<GenerateTokenUser> getUserData() async {
    final String? userDataString =
        await serviceLocator<UserCacheService>().getUserData("userData");
    GenerateTokenUser userData =
        GenerateTokenUser.fromJson(jsonDecode(userDataString!));
    return userData;
  }

  Future<void> onPickFile(
      {String type = "",
      required BuildContext context,
      required LibraryFilesModel libraryContent,
      String? folderNam}) async {
    bool fileLimitExceeded =
        libraryContent.data.where((element) => !element.isFolder).length == 5;
    if (fileLimitExceeded) {
      CustomToast.showErrorToast(msg: "File limit is exceeded!");
      return;
    }
    String? selectedFilePath = await pickFile(type: type);
    if (selectedFilePath != null) {
      File selectedFile = File(selectedFilePath);
      String fileSize = (selectedFile.readAsBytesSync().length).toString();
      FileUploadRepository fileUploadRepository = FileUploadRepository(
        baseUrl: BaseUrls.libraryBaseUrl,
        dio: ApiHelper().oConnectDio,
      );
      Loading.indicator(context);
      String fileHeader = FileUploadRepository.getFileHeader(selectedFile);
      bool? status = await fileUploadRepository.uploadLibraryFile(
          userId: (ocUserData?.id ?? 0).toString(),
          userEmail: ocUserData?.userEmail ?? "",
          purpose: "presentation",
          file: selectedFile,
          contentType: lookupMimeType(selectedFilePath) ?? "",
          filesize: fileSize,
          userInfo: fileHeader,
          folderName: folderNam);
      if (status) {
        (folderNam != null && folderNam.isNotEmpty)
            ? await getFolderFilesData(context: context, folderName: folderNam)
            : await getLibraryFilesData(context: context);
      }
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<String?> pickFile({String type = ""}) async {
    List<PlatformFile>? files;
    XFile? imageFile;

    // Determine file type and fetch files
    switch (type) {
      case "doc":
        files = await getFile(
          allowedExtension: docExt,
        );
        break;
      case "audio":
        files = await getFile(
          allowedExtension: audioExt,
        );
        break;
      case "video":
        files = await getFile(
          allowedExtension: videoExt,
        );
        break;
      case "cam":
        imageFile = await getImage(
          imageSource: ImageSource.camera,
        );
        break;
      case "gallery":
        imageFile = await getImage();
        break;
    }

    if (files != null && files.isNotEmpty) {
      return files.first.path;
    } else if (imageFile != null) {
      return imageFile.path;
    } else {
      await CustomToast.showInfoToast(msg: "Please select file");
      return null;
    }
  }

  Future<List<PlatformFile>> getFile({
    List<String> allowedExtension = const [],
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: allowedExtension,
      type: allowedExtension.isEmpty ? FileType.any : FileType.custom,
      allowMultiple: false,
    );
    return (result?.files ?? []);
  }

  Future<XFile?> getImage({
    ImageSource imageSource = ImageSource.gallery,
  }) async {
    XFile? result = await ImagePickerService.getImage(imageSource);

    return result;
  }

  void onSearch({
    String searchValue = "",
  }) {
    setSearchStatus = searchValue.isNotEmpty;
    libraryFilesModel = libraryFilesModel.copyWith(
      data: libraryData.map(
        (LibraryItem libraryItem) {
          return libraryItem.copyWith(
            canShow: (libraryItem.fileName ?? "").contains(searchValue) ||
                (libraryItem.folderName ?? "").contains(searchValue),
          );
        },
      ).toList(),
    );
    isSearchDataEmpty = libraryData.where((element) {
      return (element.canShow ?? false);
    }).isEmpty;
    notifyListeners();
  }

  List<LibraryItem> get libraryFolderData => libraryFolderFilesModel.data;

  List<LibraryItem> get presentationFolderData => libraryFolderFilesModel.data;

  void onSearchFolders({
    String searchValue = "",
  }) {
    setSearchStatus = searchValue.isNotEmpty;
    libraryFolderFilesModel = libraryFolderFilesModel.copyWith(
      data: libraryFolderData.map(
        (LibraryItem libraryItem) {
          return libraryItem.copyWith(
            canShow: (libraryItem.fileName ?? "").contains(searchValue) ||
                (libraryItem.folderName ?? "").contains(searchValue),
          );
        },
      ).toList(),
    );
    isSearchDataEmpty = libraryFolderData.where((element) {
      return (element.canShow ?? false);
    }).isEmpty;
    notifyListeners();
  }

  Future<void> createLibraryFolder({
    String folderName = "",
    required BuildContext context,
  }) async {
    FileUploadRepository fileUploadRepository = FileUploadRepository(
      baseUrl: BaseUrls.libraryBaseUrl,
      dio: ApiHelper().oConnectDio,
    );
    Loading.indicator(context);

    bool? status = await fileUploadRepository.createFolder(
      userId: (ocUserData?.id ?? 0).toString(),
      userEmail: ocUserData?.userEmail ?? "",
      purpose: "presentation",
      folderName: folderName,
      type: "folder",
    );
    if (status ?? false) {
      await getLibraryFilesData(context: context);
    }
    Navigator.pop(context);
  }

  List<String> get getSelectedFileIds {
    List<String> selectedFiles = [];
    for (var element in libraryData) {
      if (element.isSelected ?? false) {
        selectedFiles.add(element.id ?? "");
      }
    }
    return selectedFiles;
  }

  List<String> get getSelectedPresentaionFileIds {
    List<String> selectedFiles = [];
    for (var element in presentationData) {
      if (element.isSelected ?? false) {
        selectedFiles.add(element.id ?? "");
      }
    }
    return selectedFiles;
  }

  List<String> get getSelectedFolderFileIds {
    List<String> selectedFiles = [];
    for (var element in libraryFolderData) {
      if (element.isSelected ?? false) {
        selectedFiles.add(element.id ?? "");
      }
    }
    return selectedFiles;
  }

  void clearSelection({
    bool fromFolder = false,
  }) {
    if (fromFolder) {
      libraryFolderFilesModel = libraryFolderFilesModel.copyWith(
        data: libraryFolderData.map(
          (e) {
            return e.copyWith(isSelected: false);
          },
        ).toList(),
      );
    } else {
      libraryFilesModel = libraryFilesModel.copyWith(
        data: libraryData.map(
          (LibraryItem libraryItem) {
            return libraryItem.copyWith(isSelected: false);
          },
        ).toList(),
      );
    }
    notifyListeners();
  }

  Future deleteFileFolder({
    List<String> fileOrFolderIds = const [],
    required BuildContext context,
    bool fromPresentation = false,
    String folderName = "",
  }) async {
    if (fileOrFolderIds.isEmpty) {
      await CustomToast.showErrorToast(
        msg: "Please select at least one file or folder",
      );
      return;
    }
    FileUploadRepository fileUploadRepository = FileUploadRepository(
      baseUrl: BaseUrls.libraryBaseUrl,
      dio: ApiHelper().oConnectDio,
    );
    Loading.indicator(context);

    bool status = await fileUploadRepository.deleteFileOrFolder(
      fileOrFolderIds: fileOrFolderIds,
    );
    if (status) {
      if (folderName.isNotEmpty) {
        await getFolderFilesData(
          context: context,
          folderName: folderName,
        );
      } else {
        await getLibraryFilesData(
          context: context,
        );
      }
    }
    Navigator.pop(context);
    if (fromPresentation) {
      Navigator.pop(context);
    }
  }

  selectLibraryItem(LibraryItem item, {bool fromPresentation = false}) {
    if (item.isFolder && fromPresentation) {
      return;
    }
    libraryFilesModel = libraryFilesModel.copyWith(
      data: libraryData.map(
        (LibraryItem libraryItem) {
          return libraryItem.copyWith(
            isSelected: (libraryItem.id == item.id)
                ? !(libraryItem.isSelected ?? false)
                : libraryItem.isSelected,
          );
        },
      ).toList(),
    );
    isDeleteSelection = libraryData
            .where(
              (element) => element.isSelected ?? false,
            )
            .length >
        1;
    notifyListeners();
  }

  set selectFolderLibraryItem(LibraryItem item) {
    if (item.isFolder) {
      return;
    }
    libraryFolderFilesModel = libraryFolderFilesModel.copyWith(
      data: libraryFolderData.map(
        (LibraryItem libraryItem) {
          return libraryItem.copyWith(
            isSelected: (libraryItem.id == item.id)
                ? !(libraryItem.isSelected ?? false)
                : libraryItem.isSelected,
          );
        },
      ).toList(),
    );
    isDeleteSelection = libraryFolderData
            .where(
              (element) => element.isSelected ?? false,
            )
            .length >
        1;
    notifyListeners();
  }

  Future<void> presentSelectedFiles(
      {required BuildContext context, bool fromFolderView = false}) async {
    List<LibraryItem> selectedLibraryItems = [];
    if (fromFolderView) {
      selectedLibraryItems = libraryFolderData.where((element) {
        return element.isSelected ?? false;
      }).toList();
    } else {
      selectedLibraryItems = libraryData.where((element) {
        return element.isSelected ?? false;
      }).toList();
    }

    if (selectedLibraryItems.isEmpty) {
      await CustomToast.showErrorToast(msg: "Please select at least one file");
      return;
    }
    if (fromFolderView) {
      Navigator.pop(context);
    }
    Navigator.pop(context);
    await context.read<PresentationPopUpProvider>().presentSelectedFiles(
          selectedLibraryItem:
              selectedLibraryItems.first.getPresentationModelFromLibrary(
            ou: myHubInfo.id ?? 0,
          ),
          context: context,
        );
  }

  Future<void> getFolderFilesData(
      {required BuildContext context, required String folderName}) async {
    ocUserData ??= await getUserData();
    try {
      LibraryFilesModel res = await libraryRepository.fetchLibraryData(
          ocUserData?.id ?? 0, 'presentation',
          folderName: folderName, type: 'library');
      libraryFolderFilesModel = res;
      log(res.data.length.toString());
      // if (!fromMeetingRoom) {
      //   Navigator.pop(context);
      // }
    } on DioException catch (e) {
      log("getLibraryFilesData Error -- $e");
    }

    notifyListeners();
  }

  void selectLibraryRecords(
      bool fromFolder, LibraryFilesModel libraryFilesModel) {
    if (!fromFolder) {
      selectedLibraryItems = libraryFilesModel.data.where((element) {
        return element.isSelected == true;
      }).toList();
      print("length:${selectedLibraryItems.length}");
    }
    notifyListeners();
  }

  multipleDownloadRecord() {
    Loading.indicator(context);
    for (int i = 0; i < selectedLibraryItems.length; i++) {
      fileDownloadLocal(
          name: selectedLibraryItems[i].fileName ?? "",
          url: selectedLibraryItems[i].readUrl ?? "",
          context: context,
          toView: false,
          toast: (i == selectedLibraryItems.length - 1) ? true : false);
    }
  }
}
