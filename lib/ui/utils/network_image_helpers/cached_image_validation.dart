import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/chat_screen/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class ImageServiceWidget extends StatelessWidget {
  const ImageServiceWidget({super.key, required this.networkImgUrl, this.tempImage, this.imageBorderRadius, this.height, this.width});

  final String? networkImgUrl;
  final String? tempImage;
  final double? imageBorderRadius;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (_, chatProvider, __) {

      return networkImgUrl != null && networkImgUrl! != "" && !networkImgUrl!.contains("null")
          ? networkImgUrl!.endsWith(".svg")
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(imageBorderRadius ?? 5.r),
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: SvgPicture.network(
                      networkImgUrl!,
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              : (networkImgUrl!.endsWith(".xlsx") || networkImgUrl!.endsWith(".xls") || networkImgUrl!.endsWith(".pdf") || networkImgUrl!.endsWith(".pptx") || networkImgUrl!.endsWith(".txt"))
                  ? Container(
                      color: Colors.white,
                      child: SvgPicture.asset(
                        chatProvider.fileType,
                        width: width,
                        height: height,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(imageBorderRadius ?? 5.r),
                      child: SizedBox(
                        height: height,
                        width: width,
                        child: Image.network(
                          networkImgUrl!,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return SizedBox(
                              width: 20,
                              height: 20,
                              child: Image.asset(
                                AppImages.defaultContactImg,
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                          loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w),
                              );
                            }
                          },
                        ),
                      ),
                    )
          : ClipRRect(
              borderRadius: BorderRadius.circular(imageBorderRadius ?? 5.r),
              child: tempImage != null && tempImage!.isNotEmpty
                  ? Container(
                      color: Colors.green,
                      child: SvgPicture.asset(
                        tempImage!,
                        width: width,
                        height: height,
                      ),
                    )
                  : Image.asset(
                      AppImages.defaultContactImg,
                      fit: BoxFit.fill,
                      height: height,
                      width: width,
                    ),
            );
    });
  }
}
