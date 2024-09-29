import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

class MonthYearSelector extends StatefulWidget {
  const MonthYearSelector({
    super.key,
    this.initialMonth,
    this.onChanged,
  });

  final DateTime? initialMonth;
  final void Function(DateTime month)? onChanged;

  static void show(BuildContext context) {
    customShowDialog(
      context,
      const MonthYearSelector(),
    );
  }

  @override
  State<StatefulWidget> createState() => _MonthYearSelectorState();
}

class _MonthYearSelectorState extends State<MonthYearSelector> {
  late int _selectedYear;
  late int _selectedMonth;

  late final List<TupleData> months;
  late final List<int> years;

  int _initialMonthIndex = 0;
  int _initialYearIndex = 0;

  @override
  void initState() {
    super.initState();
    final now = widget.initialMonth!;
    _selectedYear = now.year;
    _selectedMonth = now.month;

    months = [
      TupleData("Jan", 1),
      TupleData("Feb", 2),
      TupleData("Mar", 3),
      TupleData("Apr", 4),
      TupleData("May", 5),
      TupleData("Jun", 6),
      TupleData("Jul", 7),
      TupleData("Aug", 8),
      TupleData("Sep", 9),
      TupleData("Oct", 10),
      TupleData("Nov", 11),
      TupleData("Dec", 12),
    ];

    final startYear = now.year - 5;
    final endYear = now.year + 5;

    years = <int>[];
    int curYearIndex = 0;
    for (int i = startYear, idx = 0; i <= endYear; i++, idx++) {
      years.add(i);
      if (i == _selectedYear) curYearIndex = idx;
    }

    _initialYearIndex = curYearIndex;
    _initialMonthIndex = _selectedMonth - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 250,
            child: Row(
              children: [
                Expanded(
                  child: _Wheel(
                    initialItemIndex: _initialMonthIndex,
                    onChanged: (index) {
                      setState(() {
                        _selectedMonth = months[index].item2;
                      });
                    },
                    children: months
                        .map(
                          (e) => Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: _selectedMonth == e.item2 ? Theme.of(context).scaffoldBackgroundColor : AppColors.mediumBG,
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: Text(e.item1, style: _selectedMonth == e.item2 ? w600_14Poppins(color: Theme.of(context).hintColor) : w400_14Poppins(color: Theme.of(context).hintColor)),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _Wheel(
                    initialItemIndex: _initialYearIndex,
                    onChanged: (index) {
                      setState(() {
                        _selectedYear = years[index];
                      });
                    },
                    children: years
                        .map(
                          (e) => Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: _selectedYear == e ? Theme.of(context).scaffoldBackgroundColor : AppColors.mediumBG,
                              borderRadius: BorderRadius.circular(16.0.r),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 8.0.w),
                            padding: EdgeInsets.all(8.r),
                            child: Center(
                              child: Text('$e', style: _selectedYear == e ? w600_14Poppins(color: Theme.of(context).hintColor) : w400_14Poppins(color: Theme.of(context).hintColor)),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  buttonText: 'Cancel',
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: CustomButton(
                  buttonText: 'Done',
                  onTap: () {
                    final day = widget.initialMonth!.day;
                    final noOfDays = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);
                    DateTime updatedDate = DateTime(_selectedYear, _selectedMonth, noOfDays < day ? 1 : day);
                    widget.onChanged?.call(updatedDate);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Wheel extends StatelessWidget {
  const _Wheel({
    required this.onChanged,
    required this.children,
    required this.initialItemIndex,
  });

  final void Function(int index) onChanged;
  final List<Widget> children;
  final int initialItemIndex;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
      itemExtent: 50,
      perspective: 0.000001,
      onSelectedItemChanged: onChanged,
      magnification: 1.1,
      useMagnifier: true,
      physics: const FixedExtentScrollPhysics(),
      controller: FixedExtentScrollController(initialItem: initialItemIndex),
      children: children,
    );
  }
}

class TupleData {
  TupleData(this.item1, this.item2);

  final String item1;
  final int item2;
}
