import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/utils/images/images.dart';

class Loading {
  static indicator(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Center(
                child: Lottie.asset(AppImages.loadingJson, width: 50.w, height: 50.w),
              )),
          // ],
        ),
      ),
    );
  }
}

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.w,
      width: 20.w,
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}
