import 'package:flutter/material.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:provider/provider.dart';

import '../../../../../core/providers/app_global_state_provider.dart';

class DraggerView extends StatefulWidget {
  final Widget child;

  const DraggerView({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _DraggerView createState() => _DraggerView();
}

class _DraggerView extends State<DraggerView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppGlobalStateProvider>(builder: (context, appGlobalStateProvider, __) {
      return Transform.translate(
        offset: Offset(
          appGlobalStateProvider.positionX,
          appGlobalStateProvider.positionY,
        ),
        child: Draggable(
          feedback: Material(
            color: Colors.transparent,
            child: widget.child,
          ),
          child: appGlobalStateProvider.dragging ? const IgnorePointer() : widget.child,
          onDragUpdate: (details) {
            appGlobalStateProvider.setDragHandlePosition = details.localPosition;
          
            appGlobalStateProvider.setDraggerEnabled(isDragging: true);
          },
          onDragEnd: (details) {
            appGlobalStateProvider.setDragHandlePosition = details.offset;
          
            appGlobalStateProvider.setDraggerEnabled(isDragging: false);
          },
        ),
      );
    });
  }
}
