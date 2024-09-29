import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

class DropDownHelper extends StatelessWidget {
  const DropDownHelper(
      {required this.selectedValue,
      required this.dropDownItems,
      required this.buttonColor,
      required this.onChanged,
      this.borderRadius,
      this.hintText,
      this.dropDownSheetColor,
      this.isExpanded = true,
      this.dropDownPadding,
      this.dropdownStyleDataPadding,
      Key? key})
      : super(key: key);
  final String selectedValue;
  final Color buttonColor;
  final List<DropdownMenuItem<String>> dropDownItems;
  final Function(String?)? onChanged;
  final double? borderRadius;
  final String? hintText;
  final Color? dropDownSheetColor;
  final bool isExpanded;
  final EdgeInsetsGeometry? dropDownPadding;
  final double? dropdownStyleDataPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          buttonStyleData:
              ButtonStyleData(decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(borderRadius ?? 0), border: Border.all(color: Theme.of(context).cardColor))),
          dropdownStyleData: DropdownStyleData(
              padding: EdgeInsets.all(dropdownStyleDataPadding ?? 4.sp), decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadius ?? 0), color: dropDownSheetColor ?? buttonColor)),
          isExpanded: isExpanded,
          hint: Text(
            hintText ?? "",
            style: w400_14Poppins(color: Theme.of(context).disabledColor),
          ),
          underline: const SizedBox.shrink(),
          iconStyleData: IconStyleData(
            icon: Padding(
              padding: dropDownPadding ?? EdgeInsets.symmetric(horizontal: 5.0.w),
              child:
                  // SvgPicture.asset(
                  //   AppImages.expandIcon,
                  //   height: 20,
                  //   color: Theme.of(context).hintColor,
                  // )
                  Icon(
                Icons.expand_more_sharp,
                size: 30.sp,
                color: Theme.of(context).hintColor.withOpacity(0.3),
              ),
            ),
            iconSize: 30.sp,
          ),
          disabledHint: Padding(
            padding: dropDownPadding ?? EdgeInsets.all(10.sp),
            child: Text(
              ConstantsStrings.selectTemplate,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: w400_14Poppins(
                color: Theme.of(context).disabledColor,
              ),
            ),
          ),
          style: w400_14Poppins(
            color: Theme.of(context).hintColor,
          ),
          value: selectedValue,
          items: dropDownItems,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
