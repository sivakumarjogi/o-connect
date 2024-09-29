import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/providers/whiteboard_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/whiteboard_tools_enum.dart';
import 'package:o_connect/ui/views/presentation/presentation_whiteboard/presentation_whiteboard_provider.dart';
import 'package:provider/provider.dart';

class SvgImageWidget extends StatelessWidget {
  const SvgImageWidget({
    Key? key,
    required this.imageName,
    required this.ontapped,
    this.selectedIcon,
    required this.fromPresentation,
  }) : super(key: key);
  final String imageName;
  final Function() ontapped;
  final SelectedWhiteBoardTool? selectedIcon;
  final bool fromPresentation;
  @override
  Widget build(BuildContext context) {
    SelectedWhiteBoardTool selectedWhiteBoardTool =
        fromPresentation ? context.watch<PresentationWhiteBoardProvider>().selectedPresentationWhiteBoardTool : context.watch<WhiteboardProvider>().selectedWhiteBoardTool;
    return InkWell(
      onTap: ontapped,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
        width: 30,
        decoration: BoxDecoration(
          color: selectedIcon == selectedWhiteBoardTool ? AppColors.mainBlueColor : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          imageName,
        ),
      ),
    );
  }
}
