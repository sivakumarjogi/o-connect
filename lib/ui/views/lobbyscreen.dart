import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_data_response/data.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';

import '../../core/providers/app_global_state_provider.dart';

class LobbyScreenPage extends StatefulWidget {
  const LobbyScreenPage({
    super.key,
    required this.meetingId,
  });

  final String meetingId;

  @override
  State<LobbyScreenPage> createState() => _LobbyScreenPageState();
}

class _LobbyScreenPageState extends State<LobbyScreenPage> with MeetingUtilsMixin {
  WebinarProvider? webinarProvider;
  late MeetingRoomProvider meetingRoomProvider;
  MeetingData? meetingDetails;
  late Future<void> _initializeControllerFuture;

  late CameraController _controllerCamera;

  late CameraDescription selectedCamera;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    webinarProvider = Provider.of<WebinarProvider>(context, listen: false);
    getAvailableCameras();
    meetingRoomProvider = Provider.of<MeetingRoomProvider>(context, listen: false);
    meetingDetails = meetingRoomProvider.meeting;

    super.initState();
  }

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

  void getAvailableCameras() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      selectedCamera = cameras.last;
      _controllerCamera = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controllerCamera.initialize();
    }
  }

  late CameraDescription? camera;

/*  camerasFunction() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    camera = firstCamera;

    if (camera != null) {
      // Check if camera is not null
      _controller = CameraController(
        camera!,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          context.read<MeetingRoomProvider>().exitFromLobby();
        },
        child: Consumer<AppGlobalStateProvider>(
          builder: (_,appGlobalStateProvider,__) {
            return AbsorbPointer(
              absorbing: !appGlobalStateProvider.isConnected,
              child: SafeArea(
                child: Stack(
                  children: [
                    // SizedBox(
                    //   height: ScreenConfig.height,
                    //   width: ScreenConfig.width,
                    //   child: Lottie.asset(
                    //     AppImages.waitingImage,
                    //     fit: BoxFit.fill,
                    //   ),
                    // ),
                    SizedBox(
                      height: ScreenConfig.height,
                      width: ScreenConfig.width,
                      child: Image.asset(
                        AppImages.waitingIcon,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 70.w,
                          width: 70.w,
                          margin: EdgeInsets.only(top: 30.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: const Color(0xff159400), border: Border.all(width: 2, color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(40.r))),
                          child: Text(
                            meetingDetails == null ? "M" : meetingDetails?.username?.split("").first.toString().toUpperCase() ?? "",
                            style: TextStyle(color: Theme.of(context).hintColor, fontSize: 30, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        height10,
                        Text(
                          meetingDetails == null ? "email" : meetingDetails!.username.toString(),
                          style: w500_14Poppins(color: Theme.of(context).hintColor),
                        ),
                        height20,
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 16.w),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Theme.of(context).scaffoldBackgroundColor),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                              "Title",
                              style: w400_12Poppins(color: Theme.of(context).hintColor.withOpacity(0.5)),
                            ),
                            height5,
                            Text(
                              meetingDetails == null ? "M" : meetingDetails!.meetingName.toString(),
                              style: w500_14Poppins(color: Colors.white),
                            ),
                            height10,

                            /// Speakers count
                            Selector<MeetingRoomProvider, int>(selector: (ctx, provider) {
                              return provider.speakersWaitingToJoin;
                            }, builder: (context, data, child) {
                              return _UserCountCard(
                                // iconPath: AppImages.union_icon,
                                title: "Speakers",
                                count: data.toString(),
                                // countWidget: Builder(
                                //   builder: (context) {
                                //     final count = context.select<MeetingRoomProvider, String>((v) => v.speakersWaitingToJoin.toString());
                                //     return _CountWidget("Speakers", count);
                                //   },
                                // ),
                              );
                            }),
                            height10,

                            /// Attendees count
                            if (meetingDetails!.meetingType != "conference")
                              Selector<MeetingRoomProvider, int>(selector: (ctx, provider) {
                                return provider.attendeesWaitingToJoin;
                              }, builder: (context, data, child) {
                                return _UserCountCard(
                                  // iconPath: AppImages.image_icon,
                                  title: "Attendees",
                                  count: data.toString(),
                                  // countWidget: Builder(
                                  //   builder: (context) {
                                  //     final count = context.select<MeetingRoomProvider, String>((v) => v.attendeesWaitingToJoin.toString());
                                  //     return _CountWidget("Attendees", count);
                                  //   },
                                  // ),
                                );
                              }),
                          ]),
                        ),

                        height15,
                        Container(
                          width: ScreenConfig.width,
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 16.w),
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
                              /*  Consumer<MeetingRoomProvider>(
                                builder: (_, meetingRoomProvider, __) {
                                  return Container(
                                    height: 180.h,
                                    width: ScreenConfig.width,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: meetingRoomProvider.videoOn != null &&
                                            meetingRoomProvider.videoOn!
                                        ? Padding(
                                            padding: EdgeInsets.all(8.0.sp),
                                            child: FutureBuilder<void>(
                                              future: _initializeControllerFuture,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  return CameraPreview(_controller);
                                                } else {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                              },
                                            ),
                                          )
                                        : SvgPicture.asset(AppImages.noVideoImage),
                                  );
                                },
                              ),*/

                              Consumer<MeetingRoomProvider>(
                                builder: (_, meetingRoomProvider, __) {
                                  return Container(
                                    height: 180.h,
                                    width: ScreenConfig.width,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: meetingRoomProvider.videoOn != null && meetingRoomProvider.videoOn!
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
                                  // comment here mic fun
                                  /*  Column(
                      children: [
                        SvgPicture.asset(AppImages.micOffIcon),
                        height5,
                        Text(
                                        "Mic",
                                        style: w400_12Poppins(
                                            color: Theme.of(context)
                                                .hintColor
                                                .withOpacity(0.5)),
                                      ),
                                    ],
                                  ),
                                  width20,*/
                                  Consumer<MeetingRoomProvider>(
                                    builder: (_, meetingRoomProvider, __) {
                                      return GestureDetector(
                                        onTap: () async {
                                          try {
                                            await _initializeControllerFuture;
                                            meetingRoomProvider.videoStatus();
                                            print("The value of video status is ${meetingRoomProvider.videoOn}");
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            meetingRoomProvider.videoOn ? SvgPicture.asset(AppImages.videoOnIcon) : SvgPicture.asset(AppImages.videoOffIcon),
                                            height5,
                                            Text(
                                              "Cam",
                                              style: w400_12Poppins(color: Theme.of(context).hintColor.withOpacity(0.5)),
                                            ),
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
                        // Text("hello ${meeting.guestKey} "),

                        // height30,.
                        /* LobbyAudioVideoTest(
                            meetingRoomProvider: meetingRoomProvider, camera: camera),*/
                        height20,
                        Selector<MeetingRoomProvider, bool>(
                          selector: (ctx, provider) {
                            return provider.isLoading;
                          },
                          builder: (_, data, __) {
                            if (data) {
                              return const SizedBox.shrink();
                            }

                            return InkWell(
                              onTap: () {
                                context.read<MeetingRoomProvider>().joinMeeting(fromLobby: true);
                              },
                              child: Container(
                                height: 48.h,
                                width: 200.w,
                                decoration: BoxDecoration(color: const Color(0xff0D9525), borderRadius: BorderRadius.circular(8.r)),
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  SvgPicture.asset(AppImages.lobbyScreenVideoCamIcon),
                                  width5,
                                  Text(
                                    "Start Meeting",
                                    style: w500_14Poppins(color: Colors.white),
                                  )
                                ]),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}

class LobbyAudioVideoTest extends StatefulWidget {
  LobbyAudioVideoTest({
    Key? key,
    required this.meetingRoomProvider,
    this.camera, // Make camera nullable
  });

  final CameraDescription? camera;
  final MeetingRoomProvider meetingRoomProvider;

  @override
  State<LobbyAudioVideoTest> createState() => _LobbyAudioVideoTestState();
}

class _LobbyAudioVideoTestState extends State<LobbyAudioVideoTest> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    if (widget.camera != null) {
      // Check if camera is not null
      _controller = CameraController(
        widget.camera!,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.camera == null) {
      return Container(); // Or some placeholder widget
    }
    return Container(
      width: ScreenConfig.width,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 16.w),
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
                child: meetingRoomProvider.videoOn != null && meetingRoomProvider.videoOn!
                    ? Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: FutureBuilder<void>(
                          future: _initializeControllerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return CameraPreview(_controller);
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      )
                    : SvgPicture.asset(AppImages.noVideoImage),
              );
            },
          ),
          height20,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SvgPicture.asset(AppImages.micOffIcon),
                  height5,
                  Text(
                    "Mic",
                    style: w400_12Poppins(color: Theme.of(context).hintColor.withOpacity(0.5)),
                  ),
                ],
              ),
              width20,
              Consumer<MeetingRoomProvider>(
                builder: (_, meetingRoomProvider, __) {
                  return GestureDetector(
                    onTap: () async {
                      try {
                        await _initializeControllerFuture;
                        meetingRoomProvider.videoStatus();
                        print("The value of video status is ${meetingRoomProvider.videoOn}");
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Column(
                      children: [
                        meetingRoomProvider.videoOn ? SvgPicture.asset(AppImages.videoOnIcon) : SvgPicture.asset(AppImages.videoOffIcon),
                        height5,
                        Text(
                          "Cam",
                          style: w400_12Poppins(color: Theme.of(context).hintColor.withOpacity(0.5)),
                        ),
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
    );
  }
}

// class LobbyAudioVideoTest extends StatefulWidget {
//    LobbyAudioVideoTest({
//     super.key,
//     required this.meetingRoomProvider,
//     required this.camera,
//   });
// final CameraDescription? camera;
//   final MeetingRoomProvider meetingRoomProvider;

//   @override
//   State<LobbyAudioVideoTest> createState() => _LobbyAudioVideoTestState();
// }

// class _LobbyAudioVideoTestState extends State<LobbyAudioVideoTest> {
// late CameraController _controller;

// late Future<void> _initializeControllerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(
//       widget.camera!,
//       ResolutionPreset.medium,
//     );
//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: ScreenConfig.width,
//       margin: EdgeInsets.symmetric(horizontal: 16.w),
//       padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 16.w),
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Theme.of(context).scaffoldBackgroundColor),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//         height10,
//         Text(
//           "Check your audio and video here",
//           style: w400_14Poppins(color: Theme.of(context).hintColor),
//         ),
//         height10,
//         // Consumer<MeetingRoomProvider>(builder: (_, meetingRoomProvider, __) {
//         //   return Container(
//         //     height:  180.h,
//         //     width: ScreenConfig.width,
//         //     // margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
//         //     decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5.r)),
//         //     child: meetingRoomProvider.localVideoTest == null ?  Padding(
//         //       padding:  EdgeInsets.all(8.0.sp),
//         //       child: SvgPicture.asset(AppImages.noVideoImage),
//         //     ) : PeerVideo(renderer: meetingRoomProvider.localVideoRenderTest),
//         //   );
//         // }),
//         Consumer<MeetingRoomProvider>(builder: (_, meetingRoomProvider, __) {
//           //  context.read<MeetingRoomProvider>().toggleVideo();
//           return Container(
//             height:  180.h,
//             width: ScreenConfig.width,
//             // margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
//             decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5.r)),
//             child:  meetingRoomProvider.videoOn != null && meetingRoomProvider.videoOn !  ? Padding(
//               padding:  EdgeInsets.all(8.0.sp),
//               child:
//                 FutureBuilder<void>(
//             future: _initializeControllerFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return CameraPreview(_controller);
//               } else {
//                 return Center(child: CircularProgressIndicator());
//               }
//             },
//           ), // Use CameraPreview instead of PeerVideo

//             ) :  SvgPicture.asset(AppImages.noVideoImage),
//           );
//         }),
//         // Container(
//         //   height: 160.h,
//         //   width: ScreenConfig.width,
//         //  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r),color: Theme.of(context).cardColor),
//         // child: Padding(
//         //   padding:  EdgeInsets.all(8.0.sp),
//         //   child: SvgPicture.asset(AppImages.noVideoImage),
//         // ),
//         // ),
//         height20,
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Column(
//               children: [
//                 SvgPicture.asset(AppImages.micOffIcon),
//                 height5,
//                 Text(
//                   "Mic",
//                   style: w400_12Poppins(color: Theme.of(context).hintColor.withOpacity(0.5)),
//                 )
//               ],
//             ),
//             width20,
//            Consumer<MeetingRoomProvider>(builder: (_, meetingRoomProvider, __){
//                 return GestureDetector(
//                   onTap: ()async {
//                      try {
//             await _initializeControllerFuture;

//                meetingRoomProvider.videoStatus() ;

//              print("The value ofvide3o status is ${ meetingRoomProvider.videoOn}");
//             // Take the picture and save it to the gallery.
//             //final image = await _controller.takePicture();
//           } catch (e) {
//             print(e);
//           }
//                     // context.read<MeetingRoomProvider>().toggleVideo();
//                     // meetingRoomProvider.update();
//                     // meetingRoomProvider.videoStatus();
//                     print("The value ofvide3o status is ${ meetingRoomProvider.videoOn}");
//                   },
//                   child: Column(
//                     children: [
//                   meetingRoomProvider.videoOn ?  SvgPicture.asset(AppImages.videoOnIcon): SvgPicture.asset(AppImages.videoOffIcon),
//                       height5,
//                       Text(
//                         "Cam",
//                         style: w400_12Poppins(color: Theme.of(context).hintColor.withOpacity(0.5)),
//                       )
//                     ],
//                   ),
//                 );
//               }
//             )
//           ],
//         ),
//         height10,
//       ]),
//     );
//     // Container(
//     //   height: ScreenConfig.height * 0.32,
//     //   margin: EdgeInsets.symmetric(horizontal: 20.w),
//     //   decoration: BoxDecoration(color: const Color(0xff16181A), borderRadius: BorderRadius.circular(10.r)),
//     //   child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//     //     height10,
//     //     Text(
//     //       "Check your audio and video here",
//     //       style: w500_14Poppins(color: Colors.white),
//     //     ),
//     //     height10,
//     //     Consumer<MeetingRoomProvider>(builder: (_, meetingRoomProvider, __) {
//     //       return Container(
//     //         height: ScreenConfig.height * 0.2,
//     //         margin: EdgeInsets.symmetric(horizontal: 16.w),
//     //         decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5.r)),
//     //         child: meetingRoomProvider.localVideoTest == null ? const SizedBox.shrink() : PeerVideo(renderer: meetingRoomProvider.localVideoRenderTest),
//     //       );
//     //     }),
//     //     height10,
//     //     Row(
//     //       mainAxisAlignment: MainAxisAlignment.center,
//     //       children: [
//     //         Column(
//     //           children: [SvgPicture.asset(AppImages.webinarMicOffIcon), const Text("Mic")],
//     //         ),
//     //         width20,
//     //         GestureDetector(
//     //           onTap: () {
//     //             context.read<MeetingRoomProvider>().toggleVideo();
//     //             meetingRoomProvider.update();
//     //           },
//     //           child: Column(
//     //             children: [SvgPicture.asset(AppImages.webinarVideoOffIcon), const Text("Cam")],
//     //           ),
//     //         ),
//     //       ],
//     //     )
//     //   ]),
//     // );
//   }
// }

// class _CountWidget extends StatelessWidget {
//   const _CountWidget(this.label, this.count);

//   final String count;
//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return RichText(
//       text: TextSpan(
//         children: [
//           TextSpan(
//             text: label,
//             style: w400_12Poppins(color: Theme.of(context).hintColor),
//           ),
//           TextSpan(
//             text: '($count)',
//             style: w400_12Poppins(color: Theme.of(context).hintColor),
//           )
//         ],
//       ),
//     );
//   }
// }

class _UserCountCard extends StatelessWidget {
  const _UserCountCard({
    required this.title,
    required this.count,
  });
  final String title;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      // width: ScreenConfig.width - 50.w,

      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xff16181A)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            count,
            style: w600_20Poppins(color: Colors.white),
          ),
          Text(
            title,
            style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
          ),
        ],
      ),
    );
  }
}
