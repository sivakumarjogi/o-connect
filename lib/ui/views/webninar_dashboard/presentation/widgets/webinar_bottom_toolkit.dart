import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/chat_screen/providers/chat_provider.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';

class WebinarBottomToolkit extends StatefulWidget {
  const WebinarBottomToolkit({
    Key? key,
  }) : super(key: key);

  @override
  State<WebinarBottomToolkit> createState() => _WebinarBottomToolkitState();
}

class _WebinarBottomToolkitState extends State<WebinarBottomToolkit> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarProvider, ParticipantsProvider>(builder: (context, data, participantProvider, child) {
      final actions = data.allowedActions;
      final myRole = participantProvider.myRole;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: data.isExpandedWebinarScreen ? 0 : 80.h,
              width: MediaQuery.of(context).size.width - 60.w,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        actions[index].onTap();
                        data.callNotify();
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: actions[index].highlight ? Theme.of(context).primaryColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  SvgPicture.asset(width: 50.w, height: 35.w, actions[index].buttonIcon),
                                  actions[index].buttonText == "Chat"
                                      ? Consumer<ChatProvider>(builder: (_, chatProvider, __) {
                                          return Visibility(
                                              visible: chatProvider.getGroupChatCount == 0 ? false : true,
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  height: 15.w,
                                                  width: 15.w,
                                                  alignment: Alignment.topRight,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(15.r)),
                                                    color: Colors.green,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      chatProvider.getGroupChatCount.toString(),
                                                      style: w600_10Poppins(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ));
                                        })
                                      : const SizedBox.shrink()
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(top: 2.h),
                                width: 65.w,
                                child: Text(
                                  actions[index].buttonText,
                                  style: w500_10Poppins(color: context.watch<WebinarThemesProviders>().colors.textColor),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(0.sp),
                    );
                  },
                  itemCount: actions.length),
            ),
          ),
          if (myRole != UserRole.unknown && myRole != UserRole.unknown && participantProvider.myRole != UserRole.guest && participantProvider.myRole != UserRole.tempBlocked)
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: data.isExpandedWebinarScreen ? 0 : 70.h,
                child: InkWell(
                  onTap: () {
                    data.toggleVideoCallViews();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SvgPicture.asset(
                          data.isGridView ? AppImages.stack_view_layout_icon : AppImages.grid_view_layout_icon,
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                            width: 65.w,
                            child: Text(
                              ConstantsStrings.layout,
                              style: w500_10Poppins(color: context.watch<WebinarThemesProviders>().colors.textColor),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            )
        ],
      );
    });
  }
}

class WebinarButtonToolkitModel {
  String buttonIcon;
  String buttonText;
  Function onTap;
  bool highlight;

  WebinarButtonToolkitModel({
    required this.buttonIcon,
    required this.buttonText,
    required this.onTap,
    this.highlight = false,
  });
}
