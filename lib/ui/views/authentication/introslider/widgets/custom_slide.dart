import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

import '../../../../../core/models/dummy_models/dummy_model.dart';

class CustomSlide extends StatelessWidget {
  final int idx;
  final PageController controller;

  const CustomSlide({super.key, required this.idx, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 230.h, child: _buildFullscreenImage(customSlideLst[idx].image)),
              height30,
              Text(customSlideLst[idx].key, maxLines: 3, textAlign: TextAlign.center, style: w600_20Poppins(color: AppColors.mainBlueColor)),
              height20,
              Text(customSlideLst[idx].key1, maxLines: 4, textAlign: TextAlign.center, textDirection: TextDirection.ltr, style: w400_14Poppins(color: Theme.of(context).primaryColorLight)),
            ],
          ),
        ));
  }

  Widget _buildFullscreenImage(String image) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: SvgPicture.asset(
        image,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    );
  }
}
