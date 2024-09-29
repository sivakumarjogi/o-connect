import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthApiProvider _authProvider;
  ApiHelper apiHelper = ApiHelper();

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthApiProvider>(context, listen: false);
    print("the seen value ${serviceLocator<UserCacheService>().getSliderScreenVisibilityValue()}");
    Future.delayed(
      const Duration(seconds: 5),
      () async {
        ScreenConfig.initiaLize(context);
        bool tokenValid = await apiHelper.updateToken(context);
        bool isUserLoggedIn = await _authProvider.checkIfUserLoggedIn();

        print("the token and isUserLogin $tokenValid && $isUserLoggedIn");
        if (mounted && tokenValid) {
        /*  !isUserLoggedIn
              ? serviceLocator<UserCacheService>()
                              .getSliderScreenVisibilityValue() ==
                          null ||
                      serviceLocator<UserCacheService>()
                              .getSliderScreenVisibilityValue() ==
                          false
                  ? Navigator.pushNamedAndRemoveUntil(
                      context, RoutesManager.introSlider, (route) => false)
                  : Navigator.pushNamedAndRemoveUntil(
                      context, RoutesManager.logIn, (route) => false)
              : Navigator.pushNamedAndRemoveUntil(
                  context, RoutesManager.homeScreen, (route) => false);*/
          if (!isUserLoggedIn) {
            if (serviceLocator<UserCacheService>().getSliderScreenVisibilityValue() == null || serviceLocator<UserCacheService>().getSliderScreenVisibilityValue() == false) {
              Navigator.pushNamedAndRemoveUntil(context, RoutesManager.introSlider, (route) => false);
              return;
            } else {
              Navigator.pushNamedAndRemoveUntil(context, RoutesManager.logIn, (route) => false);
              return;
            }
          } else {

            Navigator.pushNamedAndRemoveUntil(context, RoutesManager.homeScreen, (route) => false);
            return;
          }
        }
      },
    );
  }

  ///f,ldjdfgasa
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack( children: [
          Image.asset(
            "assets/new_ui_icons/introslider/loadingImage.png",
            height: MediaQuery.of(context).size.height*1,
            width: MediaQuery.of(context).size.width*1,
            fit: BoxFit.fill,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 220.h,
              width: 220.w,
              child: Lottie.asset(
                AppImages.splashImage,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
