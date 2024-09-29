import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/views/meeting/providers/media_devices_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/drawerHelper/drawerHelper.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:provider/provider.dart';

class SettingPopUPPage extends StatefulWidget {
  const SettingPopUPPage({super.key});

  @override
  State<SettingPopUPPage> createState() => _SettingPopUPPageState();
}

class _SettingPopUPPageState extends State<SettingPopUPPage> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarProvider, MediaDevicesProvider>(builder: (context, webinarProvider, devices, child) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showDialogCustomHeader(context, headerTitle: "Settings"),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: TabBar(
                    labelColor: Theme.of(context).focusColor,
                    labelStyle: w400_12Poppins(color: Theme.of(context).focusColor),
                    indicatorColor: Theme.of(context).focusColor,
                    unselectedLabelStyle: w400_12Poppins(color: Theme.of(context).hintColor),
                    unselectedLabelColor: Theme.of(context).hintColor,
                    controller: tabController,
                    tabs: [
                      Tab(
                          child: Text(
                        ConstantsStrings.audio,
                        style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                      )),
                      Tab(child: Text(ConstantsStrings.video, style: w400_14Poppins(color: Theme.of(context).primaryColorLight))),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: TabBarView(
                    controller: tabController,
                    children: [audioSettingsMethod(context, devices), videoSettingsMethod(context, devices)],
                  ),
                ),
              ],
            ),
          )
        ],
      );
    });
  }

  Padding videoSettingsMethod(BuildContext context, MediaDevicesProvider devices) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            height20,
            DropDownHelper(
              buttonColor: Theme.of(context).primaryColor,
              selectedValue: devices.selectedVideoDevice!.deviceId,
              dropDownItems: devices.videoInput
                  .map<DropdownMenuItem<String>>(
                    (e) => DropdownMenuItem(
                      value: e.deviceId,
                      child: Text(e.label),
                    ),
                  )
                  .toList(),
              onChanged: (String? value) {
                if (value != null) {
                  devices.setSelectedVideoDevice(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding audioSettingsMethod(BuildContext context, MediaDevicesProvider devicesProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            height20,
            DropDownHelper(
              buttonColor: Theme.of(context).primaryColor,
              selectedValue: devicesProvider.selectedAudioDevice!.deviceId,
              dropDownItems: devicesProvider.audioInput
                  .map<DropdownMenuItem<String>>(
                    (e) => DropdownMenuItem(
                      value: e.deviceId,
                      child: Text(e.label, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
              onChanged: (String? value) {
                if (value != null) {
                  devicesProvider.setSelectedAudioDevice(value);
                }
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Select audio input device',
                style: w400_12Poppins(color: Theme.of(context).disabledColor),
              ),
            ),
            height10,
          ],
        ),
      ),
    );
  }
}
