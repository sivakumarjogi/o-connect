import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';

import '../../utils/constant_strings.dart';
import '../../utils/images/images.dart';
import '../../utils/textfield_helper/app_fonts.dart';

class ProductsCard extends StatefulWidget {
  final String title;
  String? productImage;

  ProductsCard({super.key, required this.title, required this.productImage});

  @override
  State<ProductsCard> createState() => _ProductsCardState();
}

class _ProductsCardState extends State<ProductsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 0.h, bottom: 0.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Theme.of(context).primaryColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 50.w,
                      width: 50.w,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Center(
                          child: Lottie.asset(
                        AppImages.splashImage,
                      ))),
                  width10,
                  SizedBox(
                    width: 220.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,
                            style: w500_13Poppins(
                                color: Theme.of(context).hintColor)),
                        Text(
                          ConstantsStrings.moretext2 ?? "",
                          style: w400_14Poppins(
                              color: Theme.of(context).disabledColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 35.h,
                width: 60.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: Colors.blue),
                child: Center(
                  child: Text(ConstantsStrings.getIt,
                      style:
                          w400_14Poppins(color: Theme.of(context).hintColor)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
