import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/providers/my_contacts_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../utils/images/images.dart';

class SearchContactByBottomSheet extends StatelessWidget {
  const SearchContactByBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15.0), topLeft: Radius.circular(15.0)),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 5.h,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 8.h,
              width: 100.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "More",
              style: w600_16Poppins(color: Theme.of(context).primaryColorLight),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0.sp),
            child: Divider(
              color: Theme.of(context).hoverColor,
            ),
          ),
          details(context,
              imagePath: AppImages.contactViewIconSvg,
              categoryName: "View",
              count: 15, onTap: () async{
                await Provider.of<MyContactsProvider>(context, listen: false).getAllContacts(isFavoriteAPICall: 1,context: context);
                Navigator.pop(context);
          }),
          details(context,
              imagePath: AppImages.editIcon,
              categoryName: "Edit",
              count: 15, onTap: () {

          }),
          details(context,
              imagePath: AppImages.deleteIconSvg,
              categoryName: "Delete",
              count: 15, onTap: () async{
                await Provider.of<MyContactsProvider>(context, listen: false).getAllContacts(isTrashAPICall: 1,context: context);
                Navigator.pop(context);
          }),
          height15,
          Align(
              alignment: Alignment.center,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    ConstantsStrings.close,
                    style: w600_16Poppins(color: Colors.blue),
                  ))),
          SizedBox(
            height: 10.h,
          )
        ],
      ),
    );
  }
}

/// Details Container
Widget details(BuildContext context,
    {required String imagePath,
    required String categoryName,
    required int count,
    required VoidCallback onTap}) {
  return Padding(
    padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h, bottom: 2.h),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24.h,
                width: 20.w,
                child: SvgPicture.asset(
                  imagePath,
                  color: Theme.of(context).primaryColorLight,
                  height: 20,
                  width: 20,
                ),
              ),
              SizedBox(
                width: 15.w,
              ),
              Text(
                categoryName,
                style: w400_16Poppins(color: Theme.of(context).disabledColor),
              ),
              const Spacer(),
              Text("$count",
                  style:
                      w400_16Poppins(color: Theme.of(context).disabledColor)),
              SizedBox(
                width: 10.h,
              )
            ],
          ),
        ),
      ),
    ),
  );
}
