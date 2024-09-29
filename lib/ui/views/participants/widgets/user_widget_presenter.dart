import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors/colors.dart';
import '../../../utils/countrie_flags.dart';
import '../../../utils/images/images.dart';
import '../../../utils/textfield_helper/app_fonts.dart';

class UserWidgetInPresenterAndAntendeePopup extends StatelessWidget {
  const UserWidgetInPresenterAndAntendeePopup({
    super.key,
    required this.profilePic,
    required this.displayName,
    required this.country,
    required this.countryFlag,
    required this.email,
  });

  final String profilePic;
  final String displayName;
  final String country;
  final String countryFlag;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.read<WebinarThemesProviders>().headerNotchColor ,
      child: Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    if (profilePic.isNotEmpty && !profilePic.endsWith('null'))
                      Container(
                        height: 45.w,
                        width: 45.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(profilePic),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      )
                    else
                      SvgPicture.asset(
                        AppImages.allParticipants,
                        height: 40.w,
                        width: 40.w,
                        fit: BoxFit.fill,
                      ),
                    // Container(
                    //   height: 15,
                    //   width: 15,
                    //   decoration: const BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color: Colors.white,
                    //   ),
                    //   padding: EdgeInsets.all(3.sp),
                    //   child: Container(
                    //     decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                    //   ),
                    // ),
                  ],
                ),
                width20,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: w400_16Poppins(color: Theme.of(context).hintColor),
                    ),
                    // Row(
                    //   children: [
                    //     SizedBox(
                    //       width: 180.w,
                    //       child: Text(
                    //         email,
                    //         style: w400_12Poppins(color: context.watch<WebinarThemesProviders>().hintTextColor),
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    //     ),
                    //     width5,
                    //     InkWell(
                    //       onTap: () {
                    //         Clipboard.setData(ClipboardData(text: email.toString()));
                    //       },
                    //       child: Icon(
                    //         Icons.copy,
                    //         size: 12.sp,
                    //         color:  Colors.blue,
                    //       ),
                    //     ),
                    //     width5,
                    //     ///Need to add check icon json file
                    //     // SvgPicture.asset()
                    //   ],
                    // ),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Column(
                children: [
                  // TODO(appal): update flag based on country
                  Countries(countriesFlag: countryFlag),
                  height10,
                  Text(
                    country ?? "",
                    style: w400_12Poppins(color: context.watch<WebinarThemesProviders>().hintTextColor),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
