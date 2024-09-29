import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/providers/prompter_provider.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

enum PrompterMenuEnum { open, save, download }

class PrompterMenu extends StatefulWidget {
  const PrompterMenu({super.key});

  @override
  State<PrompterMenu> createState() => _PrompterMenuState();
}

class _PrompterMenuState extends State<PrompterMenu> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PrompterProvider, WebinarThemesProviders>(builder: (context, prompterProvider, webinarThemesProviders, child) {
      return Align(
        alignment: Alignment.centerRight,
        child: PopupMenuButton<PrompterMenuEnum>(
          elevation: 0,
          icon: Icon(
            Icons.more_vert,
            size: 24.sp,
            color: webinarThemesProviders.colors.textColor,
          ),
          color: Provider.of<WebinarThemesProviders>(context, listen: false).themeBackGroundColor ?? Theme.of(context).primaryColor,
          initialValue: prompterProvider.selectedMenu,
          position: PopupMenuPosition.under,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.r))),
          onSelected: (PrompterMenuEnum item) {
            prompterProvider.menuItem(item);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<PrompterMenuEnum>>[
            PopupMenuItem<PrompterMenuEnum>(
              enabled: true,
              value: PrompterMenuEnum.open,
              onTap: () {
                debugPrint(ConstantsStrings.open);
                prompterProvider.pickFile();
                // prompterProvider.screenshot();
              },
              child: Text(ConstantsStrings.open, style: w400_10Poppins(color: Theme.of(context).hintColor)),
            ),
            PopupMenuItem<PrompterMenuEnum>(
              enabled: true,
              value: PrompterMenuEnum.save,
              onTap: () async {
                await prompterProvider.getPdf();
              },
              child: Text(ConstantsStrings.save, style: w400_10Poppins(color: Theme.of(context).hintColor)),
            ),
            PopupMenuItem<PrompterMenuEnum>(
              enabled: true,
              value: PrompterMenuEnum.download,
              onTap: () async {
                debugPrint(ConstantsStrings.download);
                await prompterProvider.getPdf(open: true);
              },
              child: Text(
                ConstantsStrings.download,
                style: w400_10Poppins(color: Theme.of(context).hintColor),
              ),
            ),
          ],
        ),
      );
    });
  }
}
