import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/authentication/introslider/widgets/indicator.dart';
import '../../../../core/models/dummy_models/dummy_model.dart';
import '../../../../core/routes/routes_name.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/constant_strings.dart';
import 'widgets/custom_slide.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';

class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({super.key});

  @override
  State<IntroSliderScreen> createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {
  PageController controller = PageController();

  Future<bool> initializeController() {
    Completer<bool> completer = Completer<bool>();

    /// Callback called after widget has been fully built
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      completer.complete(true);
    });

    return completer.future;
  }

  ///dhbjfhjdsfasas
  @override
  void initState() {
    serviceLocator<UserCacheService>().seenSliderScreens(value: true);
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            height: 650.h,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    height70,
                    height40,
                    SizedBox(
                      height: 480.h,
                      child: PageView.builder(
                        controller: controller,
                        physics: const ClampingScrollPhysics(),
                        itemCount: customSlideLst.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CustomSlide(idx: index, controller: controller);
                        },
                      ),
                    ),
                    height10,
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: SizedBox(
                        height: 30.h,
                        child: Indicator(
                          controller: controller,
                        ),
                      ),
                    ),
                  ],
                ),
                height10,
                Padding(
                  padding: EdgeInsets.only(top: 30.h, left: 10.w, right: 15.w),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(context, RoutesManager.logIn, (route) => false);
                      },
                      child: Text('Skip', style: w400_14Poppins(color: Theme.of(context).primaryColorLight)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          height10,
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomButton(
              width: 120.w,
              borderRadius: 20.r,
              borderColor: AppColors.customButtonBlueColor,
              buttonColor: AppColors.customButtonBlueColor,
              buttonText: (controller.positions.isNotEmpty && customSlideLst.length - 1 == controller.page) ? ConstantsStrings.getStarted : ConstantsStrings.next,
              buttonTextStyle: w600_14Poppins(color: AppColors.whiteColor),
              onTap: () {
                if (customSlideLst.length - 1 == controller.page) {
                  Navigator.pushNamedAndRemoveUntil(context, RoutesManager.logIn, (route) => false);
                }
                controller.nextPage(duration: const Duration(milliseconds: 100), curve: Curves.bounceIn);
              },
            ),
          ),
        ],
      ),
    ));
  }
}
