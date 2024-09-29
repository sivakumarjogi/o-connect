import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_models/webinar_paichart_model.dart';

class NewGraph extends StatefulWidget {
  NewGraph(this.chartWebinarDataListData, {super.key});

  List<ChartDatas>? chartWebinarDataListData;

  @override
  State<NewGraph> createState() => _NewGraphState();
}

class _NewGraphState extends State<NewGraph> {
  List<Color> gradientColors = [
    AppColors.statusButtonBl,
    AppColors.statusButtonBl2
  ];

  bool showAvg = false;

  double largestPrati=0.0;
  double largestY=0.0;
 List<FlSpot>? spots=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // slotData();
  }

  @override
  Widget build(BuildContext context) {
    slotData();
    print("call here ${widget.chartWebinarDataListData!.length.toString()} ass spots ${spots!.length}");
    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      child: LineChart(
        /* showAvg ? avgData() :*/
        mainData(),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;

    // Assuming chartWebinarDataListData is a List<ChartDatas>
    if (widget.chartWebinarDataListData != null &&
        widget.chartWebinarDataListData!.isNotEmpty &&
        widget.chartWebinarDataListData!.length > value) {
      var onlyMonth =
          widget.chartWebinarDataListData![value.toInt()].eventName.split("-");
      text = Text(onlyMonth.first, style: style);
    } else {
      text =
          const Text('', style: style); // Default text if data is empty or null
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: false,
        horizontalInterval: 1,
        //verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.green,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.statusButtonBl.withOpacity(0.4),
            strokeWidth: .5,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        bottomTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),

      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          top: BorderSide(color: Color(0xff37434d)),
          right: BorderSide(color: Color(0xff37434d)),
          bottom: BorderSide(color: Color(0xff37434d)),
          left: BorderSide(color: Color(0xff37434d)),
          // No left border specified
        ),
        //   border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: widget.chartWebinarDataListData!.length == 1 ? -.1 : 0,
      maxX: widget.chartWebinarDataListData!.length.toDouble(),
      minY: widget.chartWebinarDataListData!.isEmpty?0:-3,
      maxY:  widget.chartWebinarDataListData!.isEmpty?0:(largestPrati + 15),
      lineBarsData: [
        LineChartBarData(
          spots: spots!,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: widget.chartWebinarDataListData!.length > 1 ? 3 : 10,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  void slotData() {
    spots=[];
    List<int> largestNumberX = [];
    List largestNumberY = [];

    if (widget.chartWebinarDataListData!.isNotEmpty) {
      for (var element in widget.chartWebinarDataListData!) {
        largestNumberX.add(element.numberOfParticipants);
        largestNumberY.add(element.eventValue);
      }
      largestNumberX.sort();
      largestNumberY.sort();

      largestPrati = largestNumberX[largestNumberX.length - 1].toDouble();
      largestY = largestNumberY[largestNumberY.length - 1].toDouble();

      for (int i = 0; i < widget.chartWebinarDataListData!.length; i++) {
        spots!.add(FlSpot(i.toDouble(), double.parse(
            widget.chartWebinarDataListData![i].numberOfParticipants.toString())));
      }
    } else {
      spots = [
        const FlSpot(0, 0),
      ];
    }
  }


}






