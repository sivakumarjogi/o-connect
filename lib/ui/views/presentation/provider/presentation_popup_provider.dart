import 'package:flutter/material.dart';
import 'package:o_connect/core/models/library_model/presentation_data_model.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/repository/library_repository/library_repo.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/utils/file_upload_mixin.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';

class PresentationPopUpProvider extends BaseProvider with WebinarFileUploadMixin, MeetingUtilsMixin {
  LibraryRepository libraryRepository = LibraryRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.libraryBaseUrl,
  );
  PresentationDataModel? selectedPresentationFiles;
  Future<void> presentSelectedFiles({
    PresentationDataModel? selectedLibraryItem,
    required BuildContext context,
  }) async {
    selectedPresentationFiles = selectedLibraryItem;
    notifyListeners();
    context.read<WebinarProvider>().setActivePage(ActivePage.presentation);
  }
}
