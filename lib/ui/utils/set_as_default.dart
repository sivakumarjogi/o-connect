import 'package:flutter/material.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

class SetAsDefault extends StatelessWidget {
  final bool showSetAsDefault;
  final bool status;
  final  String? showMessage;
  final ValueChanged<bool?>? onChanged;

  const SetAsDefault({
    super.key,
    this.status = false,
    this.onChanged,
    this.showMessage,
    this.showSetAsDefault = false,
  });

  @override
  Widget build(BuildContext context) {
    return showSetAsDefault
        ? InkWell(
            onTap: () {
              onChanged?.call(!status);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox.adaptive(
                  value: status,
                  onChanged: onChanged,
                  activeColor: Colors.blue,
                ),
                Text(
                  showMessage!,
                  style: w500_14Poppins(
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ],
            ),
          )
        : const IgnorePointer();
  }
}
