import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/participants/widgets/participant_widget.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

class SpeakersGrid extends StatelessWidget {
  const SpeakersGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantsProvider>(builder: (context, participantsProvider, __) {
      return ListView.builder(
          itemCount: participantsProvider.filteredSpeakers.length,
          itemBuilder: ((context, index) {
            return SizedBox(width: MediaQuery.of(context).size.width, child: ParticipantWidget(participant: participantsProvider.filteredSpeakers[index]));
          }));
    });

    //   ParticipantsGrid<HubUserData>(
    //   getItems: (provider) {
    //     final item = context.read<ParticipantsProvider>().filteredSpeakers;
    //     return item;
    //   },
    //   itemBuilder: (provider, item) {
    //     return ParticipantWidget(participant: item);
    //   },
    // );
  }
}

class ParticipantsGrid<T> extends StatefulWidget {
  const ParticipantsGrid({
    super.key,
    required this.itemBuilder,
    required this.getItems,
  });

  final List<T> Function(ParticipantsProvider provider) getItems;
  final Widget Function(ParticipantsProvider provider, T item) itemBuilder;

  @override
  State<ParticipantsGrid<T>> createState() => _ParticipantsGridState<T>();
}

class _ParticipantsGridState<T> extends State<ParticipantsGrid<T>> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ParticipantsProvider, WebinarThemesProviders>(
      builder: (context, provider, webinarThemesProviders, child) {
        final items = widget.getItems(provider);

        // for (var element in items) {
        //   print(element.toString());
        // }

        return Column(
          children: [
            const SizedBox(height: 6),
            if (items.isEmpty)
              Center(
                child: Text(
                  'No users found',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            Expanded(
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width > 453 ? 2.27 : 3 / 1,
                  crossAxisSpacing: 10.sp,
                  mainAxisSpacing: 10.sp,
                ),
                itemCount: items.length,
                itemBuilder: (BuildContext ctx, index) {
                  return widget.itemBuilder(provider, items[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
