import 'package:flutter/material.dart';
import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PollResultsBarGraph extends StatelessWidget {
  const PollResultsBarGraph({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<PollProvider>(builder: (_, pollProvider, __) {
      return SizedBox(
        height: 200,
        child: SfCartesianChart(
          key: ValueKey(pollProvider.pollresultsSeriesData),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(minimum: 0, maximum: 20, interval: 2),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: pollProvider.pollresultsSeriesData,
        ),
      );
    });
  }
}

class PollResultsChartData {
  PollResultsChartData(this.x, this.y, this.color);

  final String x;
  final int y;
  final Color color;
}
