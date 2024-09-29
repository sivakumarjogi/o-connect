import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/providers/common_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
// import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../core/providers/app_global_state_provider.dart';
import '../../core/screen_configs.dart';
import 'meeting/model/meeting_data_response/data.dart';

class LobbyScreenWaiting extends StatefulWidget {
  const LobbyScreenWaiting({
    super.key,
    required this.meetingUrl,
  });

  final String meetingUrl;

  @override
  State<LobbyScreenWaiting> createState() => _LobbyScreenWaitingState();
}

class _LobbyScreenWaitingState extends State<LobbyScreenWaiting> with SingleTickerProviderStateMixin {
  MeetingData? meetingDetails;
  AnimationController? _controller;

  late CameraController _controllerCamera;
  late Future<void> _initializeControllerFuture;

  late CameraDescription selectedCamera;
  late List<CameraDescription> cameras;

  void toggleCamera() {
    setState(() {
      selectedCamera = selectedCamera == cameras.first ? cameras.last : cameras.first;
      _controllerCamera = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controllerCamera.initialize();
    });
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(minutes: 15));
    meetingDetails = context.read<MeetingRoomProvider>().meeting;
    getAvailableCameras();
    _controller!.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  late CameraDescription? camera;

  void getAvailableCameras() async {
    cameras = await availableCameras();
    selectedCamera = cameras.last;
    _controllerCamera = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controllerCamera.initialize();
  }

/*  camerasFunction() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    camera = firstCamera;

    if (camera != null) {
      // Check if camera is not null
      _controllerCamera = CameraController(
        camera!,
        ResolutionPreset.medium,

      );
      _initializeControllerFuture = _controllerCamera.initialize();
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<MeetingRoomProvider>().exitFromLobby();
        return true;
      },
      child: Consumer2<CommonProvider,AppGlobalStateProvider>(builder: (context, data,appGlobalStateProvider, child) {
        return AbsorbPointer(
          absorbing: !appGlobalStateProvider.isConnected,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
                child: Stack(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      AppImages.lobbyWaiting,
                      fit: BoxFit.fill,
                    )),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ConstantsStrings.webinarOn,
                        style: w700_24Poppins(color: Theme.of(context).primaryColorLight),
                      ),
                      height10,
                      Text(
                        meetingDetails == null ? "Meeting" : meetingDetails!.meetingName.toString(),
                        style: w600_18Poppins(color: Theme.of(context).primaryColorLight),
                      ),
                      height10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          width10,
                          Text(
                            meetingDetails == null ? "Aaa 00 0000" : DateFormat("MMM dd yyyy").format(meetingDetails!.meetingDate ?? DateTime.now()).toString(),
                            style: w500_14Poppins(color: Theme.of(context).primaryColorLight),
                          )
                        ],
                      ),
                      height20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          width5,
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.63,
                            child: Center(
                              child: Text(
                                meetingDetails == null
                                    ? "00: 00"
                                    : "${DateFormat("HH:MM").format(meetingDetails!.meetingDate?.toLocal() ?? DateTime.now())} (${meetingDetails!.country} Standard time ) \n\nMeeting Starts In",
                                textAlign: TextAlign.center,
                                style: w500_14Poppins(color: Theme.of(context).primaryColorLight),
                              ),
                            ),
                          ),
                        ],
                      ),
                      height20,
                      Countdown(
                        animation: StepTween(
                          begin: 5 * 60,
                          end: 0,
                        ).animate(_controller!),
                      ),
                      height30,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30.w,
                            width: 30.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.white), borderRadius: const BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              "H",
                              style: w600_14Poppins(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          width5,
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(text: "Host", style: w500_14Poppins(color: Theme.of(context).primaryColorLight)),
                            TextSpan(text: " : ", style: w500_14Poppins(color: Theme.of(context).primaryColorLight)),
                            TextSpan(text: meetingDetails == null ? "Jone" : meetingDetails!.username, style: w500_14Poppins(color: Theme.of(context).primaryColorLight))
                          ]))
                        ],
                      ),
                      height30,
                      if (meetingDetails?.meetingType.toString() != "webinar")
                        Container(
                          width: ScreenConfig.width,
                          margin: EdgeInsets.only(left: 35.w, right: 35.w, bottom: 25.w),
                          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              height10,
                              Text(
                                "Check your video here",
                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                              ),
                              height10,
                              Consumer<MeetingRoomProvider>(
                                builder: (_, meetingRoomProvider, __) {
                                  return Container(
                                    height: 180.h,
                                    width: ScreenConfig.width,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: meetingRoomProvider.videoOn
                                        ? Stack(
                                            children: [
                                              SizedBox(
                                                height: 180.h,
                                                width: ScreenConfig.width,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0.sp),
                                                  child: FutureBuilder<void>(
                                                    future: _initializeControllerFuture,
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState == ConnectionState.done) {
                                                        return CameraPreview(_controllerCamera);
                                                      } else {
                                                        return const Center(child: CircularProgressIndicator());
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.flip_camera_ios_outlined,
                                                  color: Colors.black,
                                                ),
                                                onPressed: toggleCamera,
                                              ),
                                            ],
                                          )
                                        : SvgPicture.asset(AppImages.noVideoImage),
                                  );
                                },
                              ),
                              height20,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /*        Column(
                                  children: [
                                    selectedCamera == cameras.first ?    IconButton(
                                      icon: const Icon(Icons.camera_front_sharp),
                                      onPressed: toggleCamera,
                                    ):IconButton(
                                      icon: const Icon(Icons.video_camera_back_sharp),
                                      onPressed: toggleCamera,
                                    ),
                                  ],
                                ),*/
                                  width20,
                                  Consumer<MeetingRoomProvider>(
                                    builder: (_, meetingRoomProvider, __) {
                                      return GestureDetector(
                                        onTap: () async {
                                          try {
                                            //        await _initializeControllerFuture;
                                            meetingRoomProvider.videoStatus();
                                            print("The value of video status is ${meetingRoomProvider.videoOn}");
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            meetingRoomProvider.videoOn ? SvgPicture.asset(AppImages.videoOnIcon) : SvgPicture.asset(AppImages.videoOffIcon),
                                            /*    height5,
                                          Text(
                                            "Cam",
                                            style: w400_12Poppins(
                                                color: Theme.of(context)
                                                    .hintColor
                                                    .withOpacity(0.5)),
                                          ),*/
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              height10,
                            ],
                          ),
                        ),
                    ],
                  ),
                )
              ],
            )),
          ),
        );
      }),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key? key, required this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerHours = '0${clockTimer.inHours.remainder(60).toString()}';
    String timerMinutes = '0${clockTimer.inMinutes.remainder(60).toString()}';
    String timerSec = (clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              // width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: AppColors.statusButtonGreen.withOpacity(0.1), blurRadius: 20, spreadRadius: 3, offset: const Offset(-2, -3))],
                shape: BoxShape.circle,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 7.h,
                  ),
                  GradientText(
                    '00',
                    style: w700_36Poppins(
                      color: Theme.of(context).primaryColorLight,
                    ),
                    colors: const [AppColors.statusButtonGreen, AppColors.statusButtonGreenMore, AppColors.statusButtonWh],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 55.0.h),
              child: Text("Days",
                  style: w500_13Poppins(
                    color: Theme.of(context).primaryColorLight,
                  )),
            ),
          ],
        ),
        SizedBox(
          width: 10.w,
        ),
        /*   Container(
          width: 60.w,
          height: 70.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 7.h,
              ),
              Text("00",
                  style: w500_20Poppins(
                    color: Theme.of(context).primaryColorLight,
                  )),
              Text("Days",
                  style: w500_13Poppins(
                    color: Theme.of(context).primaryColorLight,
                  )),
            ],
          ),
        ),*/
        width10,
        /* Container(
          width: 60.w,
          height: 70.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 7.h,
              ),
              Text(timerHours,
                  style: w500_20Poppins(
                    color: Theme.of(context).primaryColorLight,
                  )),
              Text("Hours",
                  style: w500_13Poppins(
                    color: Theme.of(context).primaryColorLight,
                  )),
            ],
          ),
        ),*/

        Stack(
          children: [
            Container(
              // width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: AppColors.statusButtonBl.withOpacity(0.3), blurRadius: 20, spreadRadius: 3, offset: const Offset(-2, -3))],
                shape: BoxShape.circle,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 7.h,
                  ),
                  GradientText(
                    timerHours,
                    style: w700_36Poppins(
                        //   color: Theme.of(context).primaryColorLight,
                        ),
                    colors: const [AppColors.statusButtonBlMore, AppColors.statusButtonBlDark, AppColors.statusButtonWh],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 55.0.h),
              child: Text("Hours",
                  style: w500_13Poppins(
                    color: Theme.of(context).primaryColorLight,
                  )),
            ),
          ],
        ),
        width10,
        SizedBox(
          width: 10.w,
        ),
        /*Container(
          width: 60.w,
          height: 70.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 7.h,
              ),
              Text(timerMinutes ?? "0:0",
                  style: w500_20Poppins(
                    color: Theme.of(context).primaryColorLight,
                  )),
              Text("Minutes",
                  style: w500_13Poppins(
                    color: Theme.of(context).primaryColorLight,
                  )),
            ],
          ),
        ),*/

        Stack(
          children: [
            Container(
              // width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: AppColors.statusButtonYellow.withOpacity(0.1), blurRadius: 20, spreadRadius: 3, offset: const Offset(-2, -3))],
                shape: BoxShape.circle,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 7.h,
                  ),
                  GradientText(
                    timerMinutes ?? "0:0",
                    style: w700_36Poppins(
                      color: Theme.of(context).primaryColorLight,
                    ),
                    colors: const [AppColors.statusButtonYellow, AppColors.statusButtonYellowMore, AppColors.statusButtonWh],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 55.0.h),
              child: Text("Minutes",
                  style: w500_13Poppins(
                    color: Theme.of(context).primaryColorLight,
                  )),
            ),
          ],
        ),
        width10,
        /*       Container(
          width: 60.w,
          height: 70.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 7.h,
              ),
              Text(timerSec ?? "0:0",
                  style: w500_20Poppins(
                    color: Theme.of(context).primaryColorLight,
                  )),
              Text("Seconds",
                  style: w500_12Poppins(
                    color: Theme.of(context).primaryColorLight,
                  )),
            ],
          ),
        ),*/

        Stack(
          children: [
            Container(
              // width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: AppColors.statusButtonPin.withOpacity(0.3), blurRadius: 20, spreadRadius: 8, offset: const Offset(-2, -3))],
                shape: BoxShape.circle,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 7.h,
                  ),
                  GradientText(
                    timerSec ?? "0:0",
                    style: w700_36Poppins(
                        //   color: Theme.of(context).primaryColorLight,
                        ),
                    colors: const [AppColors.statusButtonPinMore, AppColors.statusButtonPin, AppColors.statusButtonWh],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 55.0.h),
              child: Text("Seconds",
                  style: w500_13Poppins(
                    color: Theme.of(context).primaryColorLight,
                  )),
            ),
          ],
        ),
        width10,
      ],
    );

    //   Text(
    //   "$timerText",
    //   style: TextStyle(
    //     fontSize: 110,
    //     color: Theme.of(context).primaryColor,
    //   ),
    // );
  }
}
