import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:o_connect/core/service/download_files_service.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/prompter/prompter_menu.dart';
import 'package:open_file/open_file.dart';

class PrompterProvider extends ChangeNotifier {
  PrompterMenuEnum? selectedMenu;
  String? file;
  String prompterData = "";

  final HtmlEditorController controller = HtmlEditorController();
  void setPrompterData() {
    controller.setText(prompterData);
    notifyListeners();
  }

  Future<void> storePrompterData() async {
    prompterData = await controller.getText();
    notifyListeners();
  }

  void fileEmpty({bool isFromInitState = false}) {
    file = "";
    if (!isFromInitState) {
      notifyListeners();
    }
  }

  Future getPdf({
    bool open = false,
  }) async {
    var htmlContent = await controller.getText();

    if (htmlContent.isEmpty) {
      CustomToast.showErrorToast(msg: 'Text should not be empty');
      return;
    }

    String? tempDir = await createFolder();
    File generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
      htmlContent,
      tempDir,
      "prompter_${DateTime.now().millisecondsSinceEpoch.toString()}",
    );

    CustomToast.showSuccessToast(msg: 'File saved successfully').then((value) {
      if (open) OpenFile.open(generatedPdfFile.path);
    });

    notifyListeners();
  }

  void menuItem(item) {
    selectedMenu = item;
    notifyListeners();
  }

  Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );
    if (result == null) return;
    // file = result.files.first;
    // file = result.files.single.path.toString();
    if (!result.files.first.path!.endsWith(".txt")) {
      CustomToast.showErrorToast(msg: "Allowed only text documents");
      return;
    }
    if (result.count > 0) {
      controller.setText(await File(result.files.first.path.toString()).readAsString());
    }

    notifyListeners();
  }

  void resetState() {
    selectedMenu = null;
    file = null;
    prompterData = "";
  }
}
