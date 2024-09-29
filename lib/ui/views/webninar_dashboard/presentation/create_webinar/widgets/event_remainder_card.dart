import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/drawerHelper/drawerHelper.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/provider/create_webinar_provider.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/textfield_helper/app_fonts.dart';

class EventRemainderCard extends StatefulWidget {
  const EventRemainderCard({super.key});

  @override
  State<EventRemainderCard> createState() => _EventRemainderCardState();
}

class _EventRemainderCardState extends State<EventRemainderCard> {
  CreateWebinarProvider? createWebinar;
  @override
  void dispose() {
    // TODO: implement dispose
    print("mndnfjnfjn");
    // createWebinar!.toggleEventRemainder(false);
    // Provider.of<CreateWebinarProvider>(context, listen: true).toggleEventRemainder(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10.r)),
      width: ScreenConfig.width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Consumer<CreateWebinarProvider>(builder: (_, createWebinarProvider, __) {
          return Row(
            children: [
              Checkbox(
                  value: createWebinarProvider.isEVentRemainderChecked,
                  activeColor: Colors.blue,
                  onChanged: (bool? isChecked) {
                    createWebinarProvider.toggleEventRemainder(isChecked!);
                  }),
              Text(
                "Event Remainder Alert",
                style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
              )
            ],
          );
        }),
        Text(
          "Alert Before Starting",
          style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
        ),
        height5,
        width10,
        Consumer<CreateWebinarProvider>(builder: (_, createWebinarProvider, __) {
          return IgnorePointer(
              ignoring: !createWebinarProvider.isEVentRemainderChecked,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(24.r), topLeft: Radius.circular(24.r))),
                      context: context,
                      builder: (context) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(mainAxisSize: MainAxisSize.min, children: [
                              10.h.height,
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 5.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: const Color(0xff202223)),
                                ),
                              ),
                              15.h.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Alert before starting",
                                    style: w500_14Poppins(color: Theme.of(context).primaryColorLight),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColorLight,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              5.h.height,
                              const Divider(),
                              10.h.height,
                              Selector<CreateWebinarProvider, String>(selector: (ctx, provider) {
                                return provider.selectedTime;
                              }, builder: (context, data, child) {
                                return GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: createWebinarProvider.minutesList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        createWebinarProvider.selectedTime = createWebinarProvider.minutesList[index];
                                        createWebinarProvider.update();
                                      },
                                      child: Container(
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                              color: createWebinarProvider.selectedTime == createWebinarProvider.minutesList[index] ? Colors.blue : Theme.of(context).disabledColor),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(child: Text(createWebinarProvider.minutesList[index])),
                                          )),
                                    ),
                                  ),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 2.5,
                                  ),
                                );
                              }),
                              10.h.height,
                              Row(
                                children: [
                                  CustomButton(
                                    buttonText: "Cancel",
                                    buttonColor: const Color(0xff1B2632),
                                    width: ScreenConfig.width * 0.46,
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  10.w.width,
                                  CustomButton(
                                    width: ScreenConfig.width * 0.46,
                                    buttonText: "Apply",
                                    onTap: () {
                                      createWebinarProvider.updateEventReminder(createWebinarProvider.selectedTime);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ]));
                      });
                },
                child: Container(
                  height: 35.h,
                  width: 1000,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).cardColor,
                      border: Border.all(color: createWebinarProvider.isEVentRemainderChecked ? Colors.white : Colors.white30, width: 0.2)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          createWebinarProvider.selectedTime == "" ? "Select" : createWebinarProvider.selectedTime,
                          style: w400_14Poppins(color: createWebinarProvider.isEVentRemainderChecked ? Theme.of(context).primaryColorLight : Colors.white30),
                        ),
                        SvgPicture.asset(AppImages.eventReminderImage)
                      ],
                    ),
                  ),
                ),
              ));
        }),
        width10,
      ]),
    );
  }
}
