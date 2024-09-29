import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/app_global_state_provider.dart';
import 'mini_pip_view_data.dart';

class MiniPIPView extends StatelessWidget {
  final bool isInitial;

  const MiniPIPView({super.key, this.isInitial = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppGlobalStateProvider>(builder: (context, appGlobalStateProvider, child) {
      return Visibility(
        visible: appGlobalStateProvider.isPIPEnabled == true,
        child: InkWell(
          onTap: () {
            context.read<AppGlobalStateProvider>().isPIPDisable(context);
          },
          child:  MiniPIPViewDataClass(),
        ),
      );
    });
  }
}
