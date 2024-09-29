import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/images/images.dart';

import '../textfield_helper/app_fonts.dart';

AppBar commonAppBarTitle(BuildContext context,
    {bool showPopUp = true, String? titleName, bool? logoNotVisible}) {
  return AppBar(
    toolbarHeight: 50.h,
    iconTheme:
        IconThemeData(color: Theme.of(context).disabledColor, size: 22.sp),
    elevation: 0,
    titleSpacing: 0,
    automaticallyImplyLeading:
        logoNotVisible != null && logoNotVisible! ? false : true,
    title: logoNotVisible != null && logoNotVisible!
        ? GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Icon(
                Icons.chevron_left_outlined,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          )
        : SvgPicture.asset(
            AppImages.logo,
            width: 24.w,
            height: 24.h,
          ),
    backgroundColor: Theme.of(context).cardColor,
    actions: [
      Padding(
        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width-135),
        child: Text(
          titleName!,
          style: w400_12Poppins(color: Theme.of(context).hintColor.withOpacity(0.8)),
        ),
      ),
    ],
  );
}
