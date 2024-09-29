import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/models/all_products_response_model.dart';
import 'package:o_connect/core/providers/all_products_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/icon_constants/icon_constant.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/loading_helper/loading_indicator.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:oes_chatbot/config/env.dart';
import 'package:oes_chatbot/utils/extensions/string_extensions.dart';
import 'package:oes_chatbot/utils/oes_shimmer.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

import 'package:url_launcher/url_launcher.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  List<String> imagesList = [
    AppImages.omailIcon,
    AppImages.onetIcon,
    AppImages.otrimIcon,
    AppImages.otrackerIcon,
    AppImages.owalletIcon,
    AppImages.oblessIcon,
    AppImages.ocademyIcon,
    AppImages.ochatIcon,
    AppImages.ocountingIcon,
    AppImages.ocaptureIcon,
    AppImages.ocreateIcon,
    AppImages.odeskIcon,
    AppImages.opeerIcon,
    AppImages.ovirtualIcon,
    AppImages.oditIcon,
    AppImages.oshopIcon,
  ];
  List<String> titlesList = ["OMAIL", "ONET", "OTRIM", "OTRACKER", "OWALLET", "OBLESS", "OCADEMY", "OCHAT", "OCOUNTING", "OCAPTURE", "OCREATE", "ODESK", "OPEER", "OVIRTUAL", "ODIT", "OSHOP"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.chevron_left_outlined,
              color: Theme.of(context).primaryColorLight,
            )),
        title: Text(
          "All Products",
          style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height15,
            FutureBuilder<List<AppInfo>>(
                future: AllProductsProvider.getAllApps(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    List<Widget> allApps = (snapshot.data ?? []).map((e) => _AppCard(app: e)).toList();
                    return allApps.isEmpty
                        ? const Center(
                            child: Text("No Subscribed Apps Found"),
                          )
                        : Expanded(
                            child: GridView(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 18, // horizontal spacing
                                mainAxisExtent: 55, // app card height
                                mainAxisSpacing: 18, // vertical spacing
                              ),
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                bottom: 100.0, // leave some space at the bottom, so that user will be able to see the card at full length
                                top: 8.0,
                              ),
                              children: allApps,
                            ),
                          );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ],
        ),
      )),
    );
  }
}

class _AppCard extends StatelessWidget {
  _AppCard({required this.app}) {
    _appInstallStatusFuture = isAppInstalled();
  }

  final AppInfo app;

  Future<dynamic>? _appInstallStatusFuture;

  Future<dynamic> isAppInstalled() {
    return LaunchApp.isAppInstalled(
      iosUrlScheme: app.iosUrlScheme,
      androidPackageName: app.androidPackageName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _appInstallStatusFuture,
      builder: (context, snapshot) {
        final isInstalled = snapshot.connectionState == ConnectionState.done && snapshot.data == true;

        return GestureDetector(
          onTap: () {
            _openApp(isInstalled, context);
          },
          child: Container(
            height: 70.h,
            width: 168.w,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), color: Theme.of(context).cardColor),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 45.w,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).scaffoldBackgroundColor),
                    child: Padding(
                      padding: EdgeInsets.all(8.0.sp),
                      child: SvgPicture.asset(app.assetPath),
                    ),
                  ),
                  width15,
                  Text(
                    app.appName.productNameUpperCase,
                    style: w500_14Poppins(color: Theme.of(context).hintColor),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openApp(bool isInstalled, BuildContext context) async {
    if (app.availableInStore) {
      LaunchApp.openApp(
        androidPackageName: app.androidPackageName,
        appStoreLink: app.appStoreLink,
        iosUrlScheme: app.iosUrlScheme,
        openStore: !isInstalled,
      ).catchError((e, st) {
        log('Unable to open the app', error: e, stackTrace: st);
        return -1;
      });
    } else {
      // CustomToast.showWarningToast(msg: "Coming Soon");
      String url = '';
      switch (app.appName.productNameUpperCase) {
        case 'OTRACKER':
          url = '${chatBotEnv.imageUrl}o-tracker';

          break;
        case 'OTRIM':
          url = '${chatBotEnv.imageUrl}o-trim';

          break;
        case 'ONET':
          url = '${chatBotEnv.imageUrl}o-net';

          break;
        case 'OMAIL':
          url = '${chatBotEnv.imageUrl}o-mail';

          break;
        case 'OFOUNDERS':
          url = ofounderLoginUrl;
          break;
        default:
          url = chatBotEnv.imageUrl;
      }

      Loading.indicator(context);
      bool res = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (res) {
        Navigator.pop(context);
      } else {
        CustomToast.showErrorToast(msg: 'Cannot launch URL');
      }
    }
  }
}
