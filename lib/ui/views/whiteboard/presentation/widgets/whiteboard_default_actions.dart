import 'package:flutter/material.dart';
import 'package:o_connect/core/providers/whiteboard_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/images/image_builder.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/whiteboard_tools_enum.dart';
import 'package:o_connect/ui/views/presentation/presentation_whiteboard/presentation_whiteboard_provider.dart';
import 'package:o_connect/ui/views/presentation/provider/presentation_popup_provider.dart';
import 'package:o_connect/ui/views/whiteboard/whiteboard_webview/whiteboard_callbacks.dart';
import 'package:provider/provider.dart';

class WhiteBoardTapActions extends StatelessWidget {
  const WhiteBoardTapActions({
    super.key,
    required this.callBacks,
    this.fromPresentation = false,
  });

  final CallBacks callBacks;
  final bool fromPresentation;
  @override
  Widget build(BuildContext context) {
    int noOfPages = (context.read<PresentationPopUpProvider>().selectedPresentationFiles?.presentationImages ?? []).length;
    // int noOfPages = 1;
    bool showArrows = fromPresentation && noOfPages > 1;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: ScreenConfig.height * 0.07,
        width: !showArrows ? ScreenConfig.width * 0.85 : ScreenConfig.width * 0.9,
        margin: const EdgeInsets.symmetric(vertical: 5),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10),
        //   border: Border.all(
        //     color: Colors.white,
        //   ),
        // ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              showArrows
                  ? IconButton(
                      onPressed: () {
                        context.read<PresentationWhiteBoardProvider>().changePageNumber();
                      },
                      icon: Center(child: const Icon(Icons.arrow_back_ios)),
                    )
                  : IgnorePointer(),
              SizedBox(
                width: showArrows ? ScreenConfig.width * 0.6 : ScreenConfig.width * 0.8,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    ImageBuilder(
                      selectedIcon: SelectedWhiteBoardTool.Pointer,
                      imageName: AppImages.cursor_icon,
                      ontapped: () {
                        if (fromPresentation) {
                          context.read<PresentationWhiteBoardProvider>().setWhiteBoardToolType = WhiteBoardToolType.POINTER;
                          context.read<PresentationWhiteBoardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Pointer);
                        } else {
                          context.read<WhiteboardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Pointer);
                          context.read<WhiteboardProvider>().setWhiteBoardToolType = WhiteBoardToolType.POINTER;
                        }
                        callBacks.selectSelectionMode();
                      },
                      fromPresentation: fromPresentation,
                    ),
                    ImageBuilder(
                      selectedIcon: SelectedWhiteBoardTool.Pencil,
                      imageName: AppImages.draw_icon,
                      ontapped: () {
                        if (fromPresentation) {
                          context.read<PresentationWhiteBoardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Pencil);
                          context.read<PresentationWhiteBoardProvider>().setWhiteBoardToolType = WhiteBoardToolType.Pencil;
                        } else {
                          context.read<WhiteboardProvider>().setWhiteBoardToolType = WhiteBoardToolType.Pencil;
                          context.read<WhiteboardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Pencil);
                        }
                        callBacks.selectDrawingMode();
                      },
                      fromPresentation: fromPresentation,
                    ),
                    ImageBuilder(
                      imageName: AppImages.rectangle_main,
                      selectedIcon: SelectedWhiteBoardTool.Rectangle,
                      ontapped: () {
                        if (fromPresentation) {
                          context.read<PresentationWhiteBoardProvider>().setWhiteBoardToolType = WhiteBoardToolType.SHAPES;
                          context.read<PresentationWhiteBoardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Rectangle);
                        } else {
                          context.read<WhiteboardProvider>().setWhiteBoardToolType = WhiteBoardToolType.SHAPES;
                          context.read<WhiteboardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Rectangle);
                        }
                        callBacks.drawRectangle();
                      },
                      fromPresentation: fromPresentation,
                    ),
                    ImageBuilder(
                      imageName: AppImages.triangle_icon,
                      selectedIcon: SelectedWhiteBoardTool.Triangle,
                      ontapped: () {
                        if (fromPresentation) {
                          context.read<PresentationWhiteBoardProvider>().setWhiteBoardToolType = WhiteBoardToolType.SHAPES;
                          context.read<PresentationWhiteBoardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Triangle);
                        } else {
                          context.read<WhiteboardProvider>().setWhiteBoardToolType = WhiteBoardToolType.SHAPES;
                          context.read<WhiteboardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Triangle);
                        }
                        callBacks.drawTriangle();
                      },
                      fromPresentation: fromPresentation,
                    ),
                    ImageBuilder(
                      imageName: AppImages.text_icon,
                      selectedIcon: SelectedWhiteBoardTool.Text,
                      ontapped: () {
                        if (fromPresentation) {
                          context.read<PresentationWhiteBoardProvider>().showTextEnterDialog();
                          context.read<PresentationWhiteBoardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Text);
                        } else {
                          context.read<WhiteboardProvider>().showTextEnterDialog();
                          context.read<WhiteboardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Text);
                        }
                      },
                      fromPresentation: fromPresentation,
                    ),
                    ImageBuilder(
                      ontapped: () {
                        if (fromPresentation) {
                          context.read<PresentationWhiteBoardProvider>().setWhiteBoardToolType = WhiteBoardToolType.SHAPES;
                          context.read<PresentationWhiteBoardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Line);
                        } else {
                          context.read<WhiteboardProvider>().setWhiteBoardToolType = WhiteBoardToolType.SHAPES;
                          context.read<WhiteboardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Line);
                        }
                        callBacks.drawLine();
                      },
                      imageName: AppImages.drawLine,
                      selectedIcon: SelectedWhiteBoardTool.Line,
                      fromPresentation: fromPresentation,
                    ),
                    ImageBuilder(
                      imageName: AppImages.circle_icon,
                      selectedIcon: SelectedWhiteBoardTool.Circle,
                      ontapped: () {
                        if (fromPresentation) {
                          context.read<PresentationWhiteBoardProvider>().setWhiteBoardToolType = WhiteBoardToolType.SHAPES;
                          context.read<PresentationWhiteBoardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Circle);
                        } else {
                          context.read<WhiteboardProvider>().setWhiteBoardToolType = WhiteBoardToolType.SHAPES;
                          context.read<WhiteboardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Circle);
                        }
                        callBacks.drawCircle();
                      },
                      fromPresentation: fromPresentation,
                    ),
                    ImageBuilder(
                      imageName: AppImages.gallery_icon,
                      ontapped: () async {
                        if (fromPresentation) {
                          await context.read<PresentationWhiteBoardProvider>().selectImageFromGallery();
                        } else {
                          await context.read<WhiteboardProvider>().selectImageFromGallery();
                        }
                      },
                      fromPresentation: fromPresentation,
                    ),
                    ImageBuilder(
                      imageName: AppImages.earser_icon,
                      selectedIcon: SelectedWhiteBoardTool.Earser,
                      ontapped: () {
                        if (fromPresentation) {
                          context.read<PresentationWhiteBoardProvider>().setWhiteBoardToolType = WhiteBoardToolType.Eraser;
                          context.read<PresentationWhiteBoardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Earser);
                        } else {
                          context.read<WhiteboardProvider>().setWhiteBoardToolType = WhiteBoardToolType.Eraser;
                          context.read<WhiteboardProvider>().updateSelectedWBTool(SelectedWhiteBoardTool.Earser);
                        }
                        callBacks.selectEraserMode();
                      },
                      fromPresentation: fromPresentation,
                    ),
                    ImageBuilder(
                      imageName: AppImages.undo_icon,
                      ontapped: () async {
                        await callBacks.undo();
                      },
                      fromPresentation: fromPresentation,
                    ),
                    ImageBuilder(
                      imageName: AppImages.redo_icon,
                      ontapped: () async {
                        await callBacks.redo();
                      },
                      fromPresentation: fromPresentation,
                    ),
                    ImageBuilder(
                      imageName: AppImages.refresh_icon,
                      ontapped: () async {
                        await callBacks.clearCanvas();
                        if (fromPresentation) {
                          await context.read<PresentationWhiteBoardProvider>().clearCanvas();
                        } else {
                          context.read<WhiteboardProvider>().clearCanvas();
                        }
                      },
                      fromPresentation: fromPresentation,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: ImageBuilder(
                        imageName: AppImages.file_downloading_icon,
                        ontapped: () async {
                          callBacks.downloadCanvasAsImage();
                        },
                        fromPresentation: fromPresentation,
                      ),
                    ),
                  ],
                ),
              ),
              (showArrows)
                  ? IconButton(
                      onPressed: () {
                        context.read<PresentationWhiteBoardProvider>().changePageNumber(
                              isIncrement: true,
                            );
                      },
                      icon: Center(child: const Icon(Icons.arrow_forward_ios_outlined)),
                    )
                  : IgnorePointer(),
            ],
          ),
        ),
      ),
    );
  }
}
