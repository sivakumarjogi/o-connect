import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Countries extends StatelessWidget {
  const Countries({super.key, required this.countriesFlag});

  final String? countriesFlag;

  @override
  Widget build(BuildContext context) {
    print("dlksdvldsvkdslsjlds $countriesFlag");
    return SvgPicture.network(height: 14.w, width: 14.w, "https://cdn.jsdelivr.net/gh/hampusborgos/country-flags@main/svg/${countriesFlag.toString().toLowerCase() ?? "in"}.svg");
  }
}
