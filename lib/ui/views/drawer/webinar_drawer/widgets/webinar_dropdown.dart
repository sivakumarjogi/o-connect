import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_details_provider.dart';

import '../../../../../core/models/dummy_models/dummy_model.dart';
import '../../../../utils/constant_strings.dart';

class WebinarDropDownWidget extends StatelessWidget {
  const WebinarDropDownWidget({super.key, required this.provider});

  final WebinarDetailsProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        // color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(5.sp),
      ),
      // width: MediaQuery.of(context).size.width * 1,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          isExpanded: true,
          underline: const SizedBox.shrink(),
          disabledHint: Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: const Text(
              ConstantsStrings.upcomingWebinars,
            ),
          ),
          value: provider.webinarDropDownMenuSelectedItem,
          items: webinarDropdownMenu,
          onChanged: (newValue) {
            provider.updateSelectedWebinarMenu(newValue!);
          },
        ),
      ),
    );
  }
}
