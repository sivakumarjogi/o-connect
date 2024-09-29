import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import '../../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../../utils/images/images.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';
import '../widgets/delete_item_popup.dart';
import '../widgets/image_view_with_zoom.dart';

class PresentationFiles extends StatefulWidget {
  const PresentationFiles({super.key, required this.provider});

  final LibraryProvider provider;

  @override
  State<PresentationFiles> createState() => _PresentationFilesState();
}

class _PresentationFilesState extends State<PresentationFiles> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.provider.isPresentation
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Lottie.asset(AppImages.loadingJson, height: 70.h, width: 100.w),
              ),
            )
          : widget.provider.finalUpdatedPresentationData.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.provider.finalUpdatedPresentationData.length,
                  itemBuilder: (context, i) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).primaryColor),
                      child: Padding(
                        padding: EdgeInsets.all(8.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                widget.provider.finalUpdatedPresentationData[i].url!.contains(".pdf")
                                    ? GestureDetector(
                                        onTap: () {
                                          widget.provider.openFileWithUrl(widget.provider.finalUpdatedPresentationData[i].url ?? "");
                                        },
                                        child: SvgPicture.asset(
                                          AppImages.pdfPresentationIcon,
                                          height: 60.h,
                                          width: 100.w,
                                        ),
                                      )
                                    : widget.provider.finalUpdatedPresentationData[i].url!.contains(".xls")
                                        ? GestureDetector(
                                            onTap: () {
                                              widget.provider.openFileWithUrl(widget.provider.finalUpdatedPresentationData[i].url ?? "");
                                            },
                                            child: SvgPicture.asset(
                                              AppImages.xlsPresentationIcon,
                                              height: 60.h,
                                              width: 100.w,
                                            ),
                                          )
                                        : widget.provider.finalUpdatedPresentationData[i].url!.contains(".doc")
                                            ? GestureDetector(
                                                onTap: () {
                                                  widget.provider.openFileWithUrl(widget.provider.finalUpdatedPresentationData[i].url ?? "");
                                                },
                                                child: SvgPicture.asset(
                                                  AppImages.docPresentationIcon,
                                                  height: 60.h,
                                                  width: 100.w,
                                                ),
                                              )
                                            : widget.provider.finalUpdatedPresentationData[i].url!.contains(".txt")
                                                ? GestureDetector(
                                                    onTap: () {
                                                      widget.provider.openFileWithUrl(widget.provider.finalUpdatedPresentationData[i].url ?? "");
                                                    },
                                                    child: SvgPicture.asset(
                                                      AppImages.textPresentationIcon,
                                                      height: 60.h,
                                                      width: 100.w,
                                                    ),
                                                  )
                                                : widget.provider.finalUpdatedPresentationData[i].url!.contains(".pptx")
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          widget.provider.openFileWithUrl(widget.provider.finalUpdatedPresentationData[i].url ?? "");
                                                        },
                                                        child: SvgPicture.asset(
                                                          AppImages.pptPresentationIcon,
                                                          height: 60.h,
                                                          width: 100.w,
                                                        ),
                                                      )
                                                    : InkWell(
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(5),
                                                          child: Image.network(
                                                            widget.provider.finalUpdatedPresentationData[i].url ?? "",
                                                            height: 60.h,
                                                            width: 70.w,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => PIPGlobalNavigation(
                                                                          childWidget: ImageViewWidget(
                                                                        imagePath: widget.provider.finalUpdatedPresentationData[i].url ?? "",
                                                                        fileName: widget.provider.finalUpdatedPresentationData[i].fileName ?? "",
                                                                      ))));
                                                        },
                                                      ),
                                width10,
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    widget.provider.finalUpdatedPresentationData[i].fileName ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                customShowDialog(context, ConfirmDeletePopup(id: widget.provider.finalUpdatedPresentationData[i].id.toString()));
                              },
                              child: Icon(
                                Icons.delete,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(
                    child: Text(
                      "No Records Found",
                      style: w400_15Poppins(color: Theme.of(context).hintColor),
                    ),
                  )),
    );
  }
}

// class OpenFileWidget extends StatelessWidget {
//   const OpenFileWidget({super.key, required this.filePath, required this.fileName});

//   final String filePath;
//   final String fileName;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.arrow_back_ios_rounded, color: Theme.of(context).disabledColor),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),
//                 Text(
//                   fileName,
//                   style: w500_15Poppins(color: Theme.of(context).disabledColor),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.25,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
