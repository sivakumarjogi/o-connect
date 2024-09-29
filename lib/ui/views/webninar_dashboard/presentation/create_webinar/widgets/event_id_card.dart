import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/provider/create_webinar_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../webinar_details/webinar_details_provider/webinar_provider.dart';

class EventIdCard extends StatelessWidget {
  const EventIdCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarProvider, CreateWebinarProvider>(builder: (context, webinarProvider, createWebinarProvider, child) {
      return Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10.sp)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ConstantsStrings.eventId,
                style: w500_14Poppins(color: Theme.of(context).hintColor),
              ),
              SizedBox(
                height: 40.h,
                // width: ScreenConfig.width,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: createWebinarProvider.radioListTile.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 35.h,
                        width: ScreenConfig.width * 0.5,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Theme.of(context).indicatorColor,
                            disabledColor: Theme.of(context).indicatorColor,
                            colorScheme: ThemeData().colorScheme.copyWith(
                                  onPrimary: Theme.of(context).indicatorColor,
                                ),
                          ),
                          child: RadioListTile(
                            activeColor: Colors.blue,
                            title: Text(
                              createWebinarProvider.radioListTile[index].name,
                              style: w400_14Poppins(color: createWebinarProvider.eventRadio == index ? Colors.blue : Theme.of(context).primaryColorLight),
                            ),
                            // tileColor: Theme.of(context).indicatorColor,
                            contentPadding: EdgeInsets.zero,
                            groupValue: createWebinarProvider.selectedRadioId,
                            visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                            value: index,
                            onChanged: (val) {
                              createWebinarProvider.updateRadioName(val!);
                              createWebinarProvider.eventRadio = index;
                            },
                          ),
                        ),
                      );
                    }),
              ),
              height20,
            ],
          ),
        ),
      );
    });
  }
}
