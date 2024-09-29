import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/providers/calender_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/drawer/calender/widgets/events_card.dart';
import 'package:provider/provider.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';

class ViewAllEventsWidget extends StatefulWidget {
  const ViewAllEventsWidget({super.key});

  @override
  State<ViewAllEventsWidget> createState() => _ViewAllEventsWidgetState();
}

class _ViewAllEventsWidgetState extends State<ViewAllEventsWidget> {
  late CalenderProvider cp;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    cp = Provider.of<CalenderProvider>(context, listen: false);
    filteredListBasedOnStatus();
    super.initState();
  }

  filteredListBasedOnStatus() {
    cp.updatedList = [];
    cp.updatedList.addAll(cp.events.where((element) {
      // print(element.status);
      return (cp.eventsList[cp.selectedEvents].toLowerCase() == element.status);
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            Consumer<CalenderProvider>(builder: (key, calenderProvider, child) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
            child: Wrap(
              runSpacing: 12,
              children: [
                decorationStyle(
                    context,
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: LightThemeColors.greyTextColor,
                              size: 22,
                            ),
                          ),
                        ),
                        Text(
                          "View All Events",
                          textAlign: TextAlign.start,
                          style: w500_14Poppins(
                              color: Theme.of(context).primaryColorLight),
                        ),
                      ],
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        calenderProvider.eventsList.length,
                        (index) => Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    searchController.clear();
                                    calenderProvider.setSelectedEventsItem(
                                        index, context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4.0)),
                                      color: calenderProvider.selectedEvents ==
                                              index
                                          ? Colors.blue
                                          : Theme.of(context).primaryColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        calenderProvider.eventsList[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: calenderProvider
                                                        .selectedEvents ==
                                                    index
                                                ? Colors.white
                                                : Colors.blue,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ))),
                Row(
                  children: [
                    Expanded(
                      child: CommonTextFormField(
                        fillColor: Theme.of(context).primaryColor,
                        hintText: ConstantsStrings.search,
                        onChanged: (changed) {
                          if (changed.length >= 3) {
                            cp.updatedList = [];
                            cp.updatedList = calenderProvider.events
                                .where((element) =>
                                    element.name.contains(changed) &&
                                    element.status ==
                                        cp.eventsList[cp.selectedEvents]
                                            .toLowerCase())
                                .toList();
                            calenderProvider.callNotify();
                            return;
                          }
                          if (changed.isEmpty || changed.isNotEmpty) {
                            cp.updatedList = [];
                            cp.updatedList.addAll(cp.events
                                .where((element) => (cp
                                        .eventsList[cp.selectedEvents]
                                        .toLowerCase() ==
                                    element.status))
                                .toList());
                            calenderProvider.callNotify();
                            return;
                          }
                        },
                        inputAction: TextInputAction.done,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        controller: searchController,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 8.0),
                      child: decorationStyle(
                          context,
                          InkWell(
                            onTap: () {
                              calenderProvider
                                  .fetchEventsInDay(context)
                                  .then((value) {
                                cp.updatedList = [];
                                cp.updatedList
                                    .addAll(cp.events.where((element) {
                                  return (cp.eventsList[cp.selectedEvents]
                                          .toLowerCase() ==
                                      element.status);
                                }).toList());
                              });
                            },
                            child: Icon(
                              Icons.refresh,
                              size: 27,
                              color: Theme.of(context).disabledColor,
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                    width: ScreenConfig.width * 0.96.w,
                    height: ScreenConfig.height * 0.72.h,
                    child: const EventsCard()),
              ],
            ),
          );
        }),
      ),
    );
  }
}

Widget decorationStyle(BuildContext context, child) {
  return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: child);
}
