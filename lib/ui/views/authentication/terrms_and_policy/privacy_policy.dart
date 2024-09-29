// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:oes/utils/Google_translator/google_translator.dart';
// import 'package:oes/utils/extensions/sizedbox_extension.dart';

// import '../../../utils/back_button.dart';
// import '../../../utils/size_config.dart';

// class PrivacyPolicy extends StatefulWidget {
//   const PrivacyPolicy({Key? key}) : super(key: key);

//   @override
//   State<PrivacyPolicy> createState() => _PrivacyPolicyState();
// }

// class _PrivacyPolicyState extends State<PrivacyPolicy> {
//   late InAppWebViewController inAppController;
//   int progressIndicator = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 10, left: 25),
//               child: Row(
//                 children: [
//                   const BackButtonWidget(),
//                   SizedBox(
//                     width: getProportionateScreenWidth(20),
//                   ),
//                   Text(
//                     "Privacy Policy",
//                     style: TextStyle(
//                         fontSize: getFontSize(18),
//                         color: Theme.of(context).hintColor,
//                         fontFamily: "Poppins",
//                         fontWeight: FontWeight.w500),
//                   ).translate()
//                 ],
//               ),
//             ),
//             getProportionateScreenHeight(15).height,
//             Expanded(
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   InAppWebView(
//                     initialUrlRequest: URLRequest(
//                         url: Uri.parse(
//                             "https://obs-dev.onpassive.com/auth/privacypolicy")),
//                     onProgressChanged:
//                         (InAppWebViewController controller, int progress) {
//                       inAppController = controller;
//                       progressIndicator = progress;
//                       if (progress == 100) {
//                         setState(() {});
//                       }
//                     },
//                   ),
//                   progressIndicator < 100
//                       ? const CircularProgressIndicator()
//                       : const SizedBox()
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

import '../../../utils/images/images.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  late InAppWebViewController inAppController;
  int progressIndicator = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor:Theme.of(context).cardColor,
            title: Text(
              "Privacy Policy",
              style: w500_16Poppins(color: Colors.white),
            ),
            centerTitle: true,
          ),
          height15,
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(
                          "https://obs-dev.onpassive.com/auth/privacypolicy")),
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    inAppController = controller;
                    progressIndicator = progress;
                    if (progress == 100) {
                      setState(() {});
                    }
                  },
                ),
                progressIndicator < 100
                    ? Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w)
                    : const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
