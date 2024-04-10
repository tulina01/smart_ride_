import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          mainData(),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('Jun', style: style);
        break;
      case 4:
        text = const Text('Feb', style: style);
        break;
      case 6:
        text = const Text('Mar', style: style);
        break;
      case 8:
        text = const Text('Apr', style: style);
        break;
      case 10:
        text = const Text('May', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '50';
        break;
      case 2:
        text = '100';
        break;
      case 3:
        text = '150';
        break;
      case 4:
        text = '200';
        break;
      case 5:
        text = '250';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.transparent,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 2),
            FlSpot(2, 1.6),
            FlSpot(4, 4),
            FlSpot(6, 3.8),
            FlSpot(8, 1),
            FlSpot(9, 3),
            FlSpot(10, 3),
          ],
          isCurved: false,
          color: Colors.yellow,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData:
              BarAreaData(show: true, color: Colors.yellow.withOpacity(0.3)),
        ),
        LineChartBarData(
          spots: const [
            FlSpot(0, 2),
            FlSpot(2, 1),
            FlSpot(4, 3),
            FlSpot(6, 3),
            FlSpot(8, 4.3),
            FlSpot(9, 2),
            FlSpot(10, 3),
          ],
          isCurved: false,
          color: Colors.red,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData:
              BarAreaData(show: true, color: Colors.red.withOpacity(0.5)),
        ),
      ],
    );
  }
}
