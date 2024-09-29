import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../utils/colors/colors.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../drawer/webinar_drawer/widgets/webinar_search_widget.dart';
import 'graph_new.dart';

class WebinarStatistics extends StatefulWidget {
  const WebinarStatistics({super.key});

  @override
  State<WebinarStatistics> createState() => _WebinarStatisticsState();
}

class _WebinarStatisticsState extends State<WebinarStatistics> {
  WebinarDetailsProvider? webinarDetailsProvider;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = ZoomPanBehavior(
        // Enables pinch zooming
        enablePinching: false,
        selectionRectBorderColor: Colors.red,
        selectionRectBorderWidth: 1,
        selectionRectColor: Colors.grey);
    webinarDetailsProvider = Provider.of<WebinarDetailsProvider>(context, listen: false);
  }

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void dispose() {
    webinarStatistics.dispose();
    super.dispose();
  }

  ScrollController webinarStatistics = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarDetailsProvider, HomeScreenProvider>(builder: (context, webinarProvider, homeScreenProvider, child) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: webinarStatistics,
        child: Container(
          height: webinarProvider.isShowDateRangePickerInStatistics ? ScreenConfig.height * 0.48 : ScreenConfig.height * 0.48,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Theme.of(context).cardColor),
          child: Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Padding(
                    padding: EdgeInsets.all(8.0.sp),
                    child: Text(
                      ConstantsStrings.webinarStatistcis,
                      style: w500_15Poppins(color: Theme.of(context).hintColor),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (homeScreenProvider.chartWebinarDataList.isEmpty) {
                          CustomToast.showErrorToast(msg: "No Record Found");
                        } else {
                          homeScreenProvider.getPdfStatistics(context, screenshotController).then((value) {});
                        }
                      },
                      icon: Icon(
                        Icons.file_download_outlined,
                        color: Theme.of(context).primaryColorLight,
                      ))
                ]),
                SizedBox(height: 50.h, child: DateWidget(provider: webinarProvider, screenName: "Statistics")),
                height10,
                // webinarProvider.isShowDateRangePickerInStatistics == true ? RangeCalenderWidget(provider: webinarProvider, screenName: "Statistics") : const SizedBox.shrink(),
                height10,

                Visibility(
                  visible: true,
                  child: Screenshot(
                    controller: screenshotController,
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), color: Theme.of(context).cardColor),
                      child: Padding(
                        padding: EdgeInsets.all(5.0.sp),
                        child: SizedBox(
                          height: 210.h,
                          width: MediaQuery.of(context).size.width - 55,
                          child: Column(
                            children: [
                              Expanded(
                                child: NewGraph(homeScreenProvider.chartWebinarDataListData),
                              ),
                              /*    Expanded(
                                child: SfCartesianChart(
                                    zoomPanBehavior: _zoomPanBehavior,
                                    series: <ChartSeries>[
                                      AreaSeries<ChartDatas, int>(
                                          dataSource: homeScreenProvider
                                              .chartWebinarDataListData,
                                          xValueMapper:
                                              (ChartDatas data, _) =>
                                                  int.parse(data
                                                      .eventName
                                                      .split("-")
                                                      .last
                                                      .toString()),
                                          yValueMapper:
                                              (ChartDatas data, _) =>
                                                  data.eventValue)
                                    ]),
                              ),*/

                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /* Container(
                                    decoration: const BoxDecoration(color: Color(0xff6956E5), shape: BoxShape.circle),
                                    height: 15.w,
                                    width: 15.w,
                                  ),*/
                                  SizedBox(
                                    width: 6.h,
                                  ),
                                  Text(
                                    ConstantsStrings.participants,
                                    style: w400_12Poppins(color: Theme.of(context).hintColor),
                                  ),
                                  /* width20,
                                  Container(
                                    decoration: const BoxDecoration(color: Color(0xffFB896B), shape: BoxShape.circle),
                                    height: 15.w,
                                    width: 15.w,
                                  ),
                                  SizedBox(
                                    width: 6.h,
                                  ),
                                  Text(
                                    "${ConstantsStrings.participants} \n 106",
                                    style: w400_12Poppins(color: Theme.of(context).hintColor),
                                  ),*/
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
