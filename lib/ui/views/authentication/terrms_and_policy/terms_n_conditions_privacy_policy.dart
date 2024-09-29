import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';

import '../../../utils/textfield_helper/app_fonts.dart';

class TermsNConditionsPrivacy extends StatelessWidget {
  const TermsNConditionsPrivacy({super.key, required this.appBarTitle, required this.iconName});

  final String appBarTitle;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        bottomOpacity: 0.0,
        centerTitle: false,
        title: Text(
          appBarTitle,
          style: w500_16Poppins(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 30,
            color: Theme.of(context).primaryColorLight,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: appBarTitle != "Terms & Conditions"
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    10.h.height,
                    Image.asset(
                      iconName,
                      fit: BoxFit.fill,
                      height: 200.h,
                      width: 127.w,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 27, left: 8, right: 8, bottom: 8),
                      child: Container(
                        decoration: BoxDecoration(color: Theme.of(context).cardColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome to O-CONNECT!",
                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Text("1. About this Privacy Policy",
                                    style: w600_14Poppins(
                                      color: AppColors.calendarIconColor,
                                    )),
                              ),
                              Text(
                                ConstantsStrings.aboutPrivacyPolicy,
                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text("2. Data We Collect",
                                    style: w600_14Poppins(
                                      color: AppColors.calendarIconColor,
                                    )),
                              ),
                              Text(
                                ConstantsStrings.dataWeCollect,
                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text("3. How We Use Your Personal information",
                                    style: w600_14Poppins(
                                      color: AppColors.calendarIconColor,
                                    )),
                              ),
                              Text(
                                ConstantsStrings.howWeUsePersonalInfo,
                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text("4. Your Rights Regarding Your Personal Information",
                                    style: w600_14Poppins(
                                      color: AppColors.calendarIconColor,
                                    )),
                              ),
                              Text(
                                ConstantsStrings.rightsRegardingPersonalInfo,
                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text("5. Children’s Privacy",
                                    style: w600_14Poppins(
                                      color: AppColors.calendarIconColor,
                                    )),
                              ),
                              Text(
                                ConstantsStrings.childrensPrivacy,
                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text("6. Cookies and Similar Technologies Policy",
                                    style: w600_14Poppins(
                                      color: AppColors.calendarIconColor,
                                    )),
                              ),
                              Text(
                                ConstantsStrings.cookiesNsimilar,
                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text("7. Legal and Law Enforcement",
                                    style: w600_14Poppins(
                                      color: AppColors.calendarIconColor,
                                    )),
                              ),
                              Text(
                                ConstantsStrings.legalandLaw,
                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text("8. Applicable Law",
                                    style: w600_14Poppins(
                                      color: AppColors.calendarIconColor,
                                    )),
                              ),
                              Text(
                                ConstantsStrings.applicableLaw,
                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text("9. Changes to this Privacy Policy",
                                    style: w600_14Poppins(
                                      color: AppColors.calendarIconColor,
                                    )),
                              ),
                              Text(
                                ConstantsStrings.changesToPrivacy,
                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                              ),
                              //
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  10.h.height,
                  Image.asset(
                    iconName,
                    height: 140.h,
                    width: 110.w,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Container(
                      decoration: BoxDecoration(color: Theme.of(context).cardColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "IMPORTANT, READ CAREFULLY:",
                              style: w600_14Poppins(color: AppColors.calendarIconColor),
                            ),
                            5.h.height,
                            Text(
                              ConstantsStrings.terms_important,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "REQUIRMENTS",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.requirments,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 1: YOUR PRIVACY",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase1,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 2: USE OF THE SERVICE AND YOUR LIABILITIES",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase2,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 3: LIMITATION ON USE",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase3,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 4: YOUR CONTENT",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase4,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 5: CODE OF CONDUCT",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase5,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 6: ELIGIBILITY",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase6,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                ConstantsStrings.cluase62,
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 7: USE OF SERVICE AND SUPPORT",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase7,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 8: ENFORCEMENT",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase8,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 9: INDEMNITY AND REMEDIES",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase9,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 10: LIMITATION OF LIABLITY",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase10,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 11: CONFIDENTIALITY",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase11,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 12: NO PARTNERSHIP OR AGENCY",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase12,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 13: TERMINATION",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase13,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 14: CHARGES AND PAYMENT TERMS",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase14,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 15: Cancellation Subscription and Refund Amount",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase15,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 16: WAIVER AND SEVERANCE",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase16,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 17. INTELLECTUAL PROPERTY",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase17,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 18: ENTIRE AGREEMENT",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase18,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 19: AMENEMDNETS AND CHANGE",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase19,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "CLAUSE 20: LAW AND JURISDICTION",
                                style: w600_14Poppins(color: AppColors.calendarIconColor),
                              ),
                            ),
                            Text(
                              ConstantsStrings.cluase20,
                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
