import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/common_app_bar/custom_expansion_tile_FAQ.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:provider/provider.dart';

class FAQsPage extends StatefulWidget {
  const FAQsPage({super.key});

  @override
  State<FAQsPage> createState() => _FAQsPageState();
}

class _FAQsPageState extends State<FAQsPage> {
  TextEditingController searchController = TextEditingController();
  late AuthApiProvider authApiProvider;

  @override
  void initState() {
    authApiProvider = Provider.of<AuthApiProvider>(context, listen: false);
    authApiProvider.getFaq();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.chevron_left_sharp,
                color: Theme.of(context).primaryColorLight,
                size: 30.sp,
              )),
          title: Text(
            ConstantsStrings.Faq,
            style: w500_14Poppins(color: Theme.of(context).hintColor),
          ),
        ),
        body: Consumer<AuthApiProvider>(builder: (context, authApiProvider, child) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                children: [
                  height10,
                  CommonTextFormField(
                    onChanged: (searchedText) {
                      authApiProvider.localSearchForFaq(searchedText);
                    },
                    controller: searchController,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    borderColor: Theme.of(context).primaryColorDark,
                    style: w400_16Poppins(color: Theme.of(context).primaryColorLight),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(4.0.sp),
                      child: Icon(
                        Icons.search,
                        color: AppColors.lightDarkColor,
                        size: 20.sp,
                      ),
                    ),
                    hintText: ConstantsStrings.search,
                    hintStyle: w400_16Poppins(color: Theme.of(context).primaryColorLight),
                  ),
                  height10,
                  CustomExpansionTileFAQ(),
                ],
              ),
            ),
          );
        }));
  }
}
