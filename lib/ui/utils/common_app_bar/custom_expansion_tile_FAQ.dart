import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:provider/provider.dart';

class CustomExpansionTileFAQ extends StatefulWidget {
  const CustomExpansionTileFAQ({super.key});

  @override
  _CustomExpansionTileFAQState createState() => _CustomExpansionTileFAQState();
}

class _CustomExpansionTileFAQState extends State<CustomExpansionTileFAQ> with SingleTickerProviderStateMixin {
  late AuthApiProvider authApiProvider;

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;
  int _expandedIndex = -1;

  @override
  void initState() {
    super.initState();
    authApiProvider = Provider.of<AuthApiProvider>(context, listen: false);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion(int index) {
    setState(() {
      if (index == _expandedIndex) {
        _isExpanded = !_isExpanded;
      } else {
        _isExpanded = true;
        _expandedIndex = index;
      }

      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse().then((_) {
          setState(() {
            _expandedIndex = -1;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthApiProvider>(builder: (context, authApiProvider, child) {
      return authApiProvider.isLoading
          ? Center(
              child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w),
            )
          : authApiProvider.finalUpdatedFaqList.isNotEmpty
              ? Flexible(
                  child: ListView.builder(
                    itemCount: authApiProvider.finalUpdatedFaqList.length,
                    itemBuilder: (context, index) {
                      // final item = _items[index];
                      return CustomExpansionPanel(
                        index: index,
                        headerValue: "${index + 1}.  ${authApiProvider.finalUpdatedFaqList[index].questions}" ?? "",
                        expandedValue: authApiProvider.finalUpdatedFaqList[index].answers!.replaceAll("<p>", "").replaceAll("</p>", "") ?? "",
                        isExpanded: index == _expandedIndex,
                        onTap: () {
                          _toggleExpansion(index);
                        },
                        animation: _animation,
                      );
                    },
                  ),
                )
              : Text(
                  "No Records Found",
                  style: w500_15Poppins(color: Theme.of(context).primaryColorLight),
                );
    });
  }
}

class Item {
  Item({
    required this.headerValue,
    required this.expandedValue,
  });

  String headerValue;
  String expandedValue;
}

class CustomExpansionPanel extends StatelessWidget {
  const CustomExpansionPanel({super.key, required this.headerValue, required this.expandedValue, required this.isExpanded, required this.onTap, required this.animation, required this.index});

  final String headerValue;
  final String expandedValue;
  final bool isExpanded;
  final VoidCallback onTap;
  final Animation<double> animation;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthApiProvider>(builder: (context, authApiProvider, child) {
      return Container(
        margin: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            Column(
              children: [
                InkWell(
                  onTap: onTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: isExpanded
                          ? BorderRadius.only(
                              topLeft: Radius.circular(5.r),
                              topRight: Radius.circular(5.r),
                            )
                          : BorderRadius.circular(5.r),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(headerValue ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, style: w400_14Poppins(color: Theme.of(context).primaryColorLight)),
                        ),
                        AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: isExpanded ? animation.value * 1 * 3.141592 : 0,
                              child: child,
                            );
                          },
                          child: Icon(
                            Icons.expand_more,
                            color: Theme.of(context).primaryColorLight,
                            size: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: ConstrainedBox(
                    constraints: isExpanded ? const BoxConstraints() : const BoxConstraints(maxHeight: 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                      ),
                      child: isExpanded
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: isExpanded
                                      ? BorderRadius.only(
                                          bottomLeft: Radius.circular(5.r),
                                          bottomRight: Radius.circular(5.r),
                                        )
                                      : BorderRadius.circular(5.r)),
                              child: Padding(
                                padding: EdgeInsets.all(10.0.sp),
                                child: Text(
                                  expandedValue,
                                  style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
