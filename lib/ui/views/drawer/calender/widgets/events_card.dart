import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/core/providers/calender_provider.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/drawer/calender/widgets/cancel_reason_pop_up.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/create_webinar_screen.dart';
import 'package:provider/provider.dart';

class EventsCard extends StatefulWidget {
  const EventsCard({
    super.key,
  });

  @override
  State<EventsCard> createState() => _EventsCardState();
}

class _EventsCardState extends State<EventsCard> {
  TextEditingController cancelReasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<CalenderProvider>(builder: (context, caleProv, child) {
      return caleProv.updatedList != null && caleProv.updatedList.isNotEmpty
          ? ListView.separated(
              separatorBuilder: (BuildContext context, int index) => const Divider(
                    thickness: 2,
                  ),
              itemCount: caleProv.updatedList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                    height: 55.h,
                                    width: 55.h,
                                    decoration: BoxDecoration(
                                      // border: Border.all(color: Colors.black,width: 2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: SvgPicture.network(
                                      caleProv.updatedList[index].image,
                                      fit: BoxFit.fill,
                                      height: 55.h,
                                      width: 40.w,
                                    )),
                                Container(height: 25.h, width: 25.w, color: Colors.white, child: Lottie.asset(AppImages.splashImage))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    caleProv.updatedList[index].name,
                                    style: w500_14Poppins(color: Theme.of(context).primaryColorLight),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${DateFormat.MMMd().format(DateTime.parse((caleProv.updatedList[index].startTime).toString()))} , "
                                    "${DateFormat("hh:mm aa").format(caleProv.updatedList[index].startTime)}"
                                    " - "
                                    "${DateFormat("hh:mm aa").format(caleProv.updatedList[index].endTime)}",
                                    style: w500_14Poppins(color: Theme.of(context).disabledColor),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        height10,
                        Visibility(
                            visible: caleProv.eventsList[caleProv.selectedEvents] == caleProv.eventsList.first ? true : false,
                            child: Row(
                              children: [
                                CustomButton(
                                  buttonText: "Cancel",
                                  width: 85.w,
                                  height: 32.h,
                                  buttonColor: const Color(0xff03BAF5).withOpacity(0.2),
                                  buttonTextStyle: w600_14Poppins(color: AppColors.mainBlueColor),
                                  onTap: () {
                                    customShowDialog(
                                        context,
                                        CancelReasonPopUp(
                                          controller: cancelReasonController,
                                          events: caleProv.updatedList[index].id,
                                        ));
                                  },
                                ),
                                width15,
                                CustomButton(
                                  buttonText: "Edit",
                                  buttonColor: Colors.transparent,
                                  borderColor: AppColors.mainBlueColor,
                                  buttonTextStyle: w600_14Poppins(color: Colors.white),
                                  width: 85.w,
                                  height: 32.h,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PIPGlobalNavigation(
                                                    childWidget: CreateWebinarScreen(
                                                  eventModel: caleProv.updatedList[index],
                                                ))));
                                  },
                                ),
                                width15,
                                Consumer<AppGlobalStateProvider>(builder: (context, appGlobalStateProvider, __) {
                                  return CustomButton(
                                    buttonText: "Join",
                                    width: 85.w,
                                    height: 32.h,
                                    buttonTextStyle: w600_14Poppins(color: Colors.white),
                                    onTap: () {
                                      if (appGlobalStateProvider.isPIPEnabled) {
                                        CustomToast.showErrorToast(msg: "Another meeting is on going...");
                                      } else {
                                        Navigator.pushNamed(context, RoutesManager.lobbyScreen);
                                      }
                                    },
                                  );
                                })
                              ],
                            )),
                      ],
                    ),
                  ),
                );
              })
          : SizedBox(
              height: ScreenConfig.height * 0.6,
              child: Center(
                child: Text(
                  "No Records Found",
                  style: w500_15Poppins(color: Colors.white),
                ),
              ),
            );
    });
  }
}
