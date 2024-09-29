import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../utils/colors/colors.dart';
import '../../../utils/custom_toast_helper/custom_toast.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../authentication/Auth_providers/auth_api_provider.dart';

class ReferalScreen extends StatefulWidget {
  const ReferalScreen({super.key});

  @override
  State<ReferalScreen> createState() => _ReferalScreenState();
}

class _ReferalScreenState extends State<ReferalScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthApiProvider>(builder: (context, authApiProvider, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          elevation: null,
          bottomOpacity: 0.0,
          centerTitle: true,
          title: Text(
            ConstantsStrings.referAndEarn,
            style: w500_16Poppins(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 35,
              color: Theme.of(context).primaryColorLight,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8)),
                // width: MediaQuery.of(context).size.width - 40,
                height: ScreenConfig.height * 0.51,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.referralLink,
                      width: 300.w,
                      height: 230.w,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Text(
                        ConstantsStrings.referealCode,
                        style: w400_14Poppins(color: Colors.white),
                      ),
                    ),
                    Padding(
                     padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                      child: Container(
                        decoration: BoxDecoration(color: Color(0xff202223), borderRadius: BorderRadius.circular(20)),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius:  Radius.circular(25.r),
                          dashPattern: const [5, 5],
                          color: Color(0xff5E6272),
                          strokeWidth: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Text(
                                  "${authApiProvider.profileData?.data?.referenceCode}",
                                  style: w500_14Poppins(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical: 5.h),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Share.share(authApiProvider.profileData?.data?.referenceCode ?? '');
                                        },
                                        child: roundedIcon(AppImages.forwardIcon)),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    GestureDetector(
                                        onTap: () async {
                                          await Clipboard.setData(ClipboardData(text: authApiProvider.profileData?.data?.referenceCode ?? ""));
                                
                                          CustomToast.showSuccessToast(msg: ConstantsStrings.copiedSuccessfully);
                                        },
                                        child: roundedIcon(AppImages.copyLinkIcon)),
                                    const SizedBox(
                                      width: 5,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8)),
                // height: 220.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.h.height,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ConstantsStrings.yourAffliatelink,
                        style: w400_16Poppins(color: Colors.blue),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ConstantsStrings.affliateText,
                        style: w400_14Poppins(color: Colors.white),
                      ),
                    ),
                    Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                        child: Container(
                          height: 55.h,
                          decoration: BoxDecoration(color: Color(0xff202223), borderRadius: BorderRadius.circular(20)),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius:  Radius.circular(25.r),
                            dashPattern: const [5, 5],
                            color: Color(0xff5E6272),
                            strokeWidth: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "https://obs-qa.onpassive.com/auth",
                                    style: w400_12Poppins(
                                      color: Colors.white,
                                    ).copyWith(overflow: TextOverflow.ellipsis),
                                  )),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Share.share('https://obs-qa.onpassive.com/auth');
                                          },
                                          child: roundedIcon(AppImages.forwardIcon)),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      GestureDetector(
                                          onTap: () async {
                                            await Clipboard.setData(const ClipboardData(text: 'https://obs-qa.onpassive.com/auth'));

                                            CustomToast.showSuccessToast(msg: ConstantsStrings.copiedSuccessfully);
                                          },
                                          child: roundedIcon(AppImages.copyLinkIcon)),
                                      const SizedBox(
                                        width: 5,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                  height10,
                  ],
                ),
              ),
            )
          ],
        )),
      );
    });
  }

  Widget roundedIcon(
    String? icon,
  ) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).scaffoldBackgroundColor),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SvgPicture.asset(
          icon!,
          height: 20.h,
          // width: 10.w,
        ),
      ),
    );
  }
}
