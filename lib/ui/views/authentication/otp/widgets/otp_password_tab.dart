import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:provider/provider.dart';

class OtpAndPasswordTab extends StatelessWidget {
  final Function? onTap;

  const OtpAndPasswordTab({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 230.0.w,
        height: 45.0.h,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(
            Radius.circular(50.r),
          ),
        ),
        child: Consumer<AuthApiProvider>(builder: (context, authProvider, child) {
          return Stack(
            children: [
              AnimatedAlign(
                alignment: Alignment(authProvider.isOtpPasswordStatus ? 1 : -1, 0),
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: 230.0.w * 0.5,
                  margin: EdgeInsets.all(4.sp),
                  height: 50.h,
                  decoration: BoxDecoration(
                    color:AppColors.customButtonBlueColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0.r),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (onTap != null) {
                    onTap!();
                  }
                  authProvider.updateOtpPasswordStatus(status: false);
                },
                child: Align(
                  alignment: const Alignment(-1, 0),
                  child: Container(
                    width: 230.0.w * 0.5,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text("Password", style: w600_14Poppins(color: Colors.white)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  authProvider.updateOtpPasswordStatus(status: true);
                },
                child: Align(
                  alignment: const Alignment(1, 0),
                  child: Container(
                    width: 230.0.w * 0.5,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text('OTP', style: w600_14Poppins(color: Colors.white)),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
