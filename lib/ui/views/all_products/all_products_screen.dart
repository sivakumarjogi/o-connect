import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/all_products/products_card.dart';

import '../../utils/images/images.dart';

class AllproductsScreen extends StatelessWidget {
  const AllproductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r))),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          showDialogCustomHeader(context, headerTitle: ConstantsStrings.allProducts),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: 6,
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index) {
                return ProductsCard(title: ConstantsStrings.OMail ?? "", productImage: AppImages.mailIcon);
              },
              separatorBuilder: (context, index) => height10,
            ),
          ),
          height10,
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  ConstantsStrings.close,
                  style: w600_18Poppins(color: Colors.blue),
                )),
          ),
        ],
      ),
    );
  }
}
