import 'package:flutter/material.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/ui/views/pip_views/mini_pip_view.dart';
import 'package:provider/provider.dart';

import '../webninar_dashboard/presentation/widgets/dragger_view.dart';

class PIPGlobalNavigation extends StatelessWidget {
  final Widget? childWidget;

  const PIPGlobalNavigation({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppGlobalStateProvider>(builder: (context, appGlobalStateProvider, child) {
      return Material(
        child: Stack(
          children: [
            childWidget!,
            const DraggerView(child: MiniPIPView()),
          ],
        ),
      );
    });
  }
}

Future push(context, pageName) {
  return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => Material(
                child: Stack(
                  children: [pageName, const DraggerView(child: MiniPIPView())],
                ),
              )));
}

Future pushNamedAndRemoveUntil(context, pageName) {
  return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (_) => Material(
                child: Stack(
                  children: [pageName, const DraggerView(child: MiniPIPView())],
                ),
              )),
      (route) => false);
}
