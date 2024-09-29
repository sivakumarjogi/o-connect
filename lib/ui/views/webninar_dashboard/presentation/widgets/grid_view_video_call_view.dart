import 'package:flutter/material.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/peers_provider.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/peer_widget.dart';
import 'package:provider/provider.dart';

import 'spotlight_user.dart';

class GridViewVideoCallView extends StatelessWidget {
  const GridViewVideoCallView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<PeersProvider, MeetingRoomProvider>(
      builder: (context, peersProvider, mRoomProvider, child) {
        final peers = [
          mRoomProvider.peer,
          ...peersProvider.peers,
        ];
        final hasMoreThan4Peers = peers.length > 4;

        if (peers.length <= 2) {
          return const SpotlightWidget();
        }

        return GridView.builder(
          scrollDirection: Axis.vertical /* hasMoreThan4Peers ? Axis.horizontal : Axis.vertical */,
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            mainAxisExtent: (hasMoreThan4Peers ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height * 0.4) / 2,
          ),
          itemCount: peers.length,
          itemBuilder: (context, index) {
            final peer = peers.elementAt(index);
            debugPrint("the peer roles are the $index ${peers[index].role}");
            return PeerWidget(
              peer: peer,
              index: index,
            );
          },
        );
      },
    );
  }
}
