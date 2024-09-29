import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/views/authentication/form_validations.dart';
import '../../../utils/textfield_helper/common_textfield.dart';

class DynamicTextField extends StatelessWidget {
  final String? initialValue;
  final void Function(String)? onChanged;
  final String hintText;
  final Widget icon;
  final Color fillColor;
  final TextEditingController? controller;

  const DynamicTextField({super.key, this.initialValue, this.onChanged, required this.hintText, required this.icon, required this.fillColor, this.controller});

  @override
  Widget build(BuildContext context) {
    return CommonTextFormField(
      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 0),
      controller: controller ?? TextEditingController(),
      hintText: hintText,
      suffixIcon: icon,
      validator: (val, String? f) {
        return FormValidations.requiredFieldValidation(val, "This field is required");
      },
      // style: TextStyle(fontSize: 12.sp,color: Colors.black),
      keyboardType: TextInputType.text,
      fillColor: fillColor,
      onChanged: onChanged,
    );
  }
}
