
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:indieflow/models/charts/bar_chart_data_item.dart';
import 'package:indieflow/utils/extensions.dart';



class BarStyleChartWidget extends StatefulWidget {

  final List<BarChartDataItem> chartItems;
  const BarStyleChartWidget({super.key, required this.chartItems});

  @override
  State<StatefulWidget> createState() => _BarStyleChartWidgetState();
}

class _BarStyleChartWidgetState extends State<BarStyleChartWidget> {

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Container(
        margin: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: AppColors.itemsBackground,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: _BarChart(widget.chartItems),
      ),
    );
  }
}

class _BarChart extends StatelessWidget {

  final List<BarChartDataItem> _chartItems;
  const _BarChart(this._chartItems);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: _chartGroups(),
        gridData: const FlGridData(show: true),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: true,
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
        BarChartGroupData group,
        int groupIndex,
        BarChartRodData rod,
        int rodIndex,
      ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            color: AppColors.contentColorCyan,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: AppColors.contentColorBlue,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = _chartItems[value.toInt()].title;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  LinearGradient get _barsGradient => const LinearGradient(
    colors: [
      AppColors.contentColorBlue,
      AppColors.contentColorCyan,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> _chartGroups() {
    return _chartItems.map((chartItem) =>
    BarChartGroupData(
      x: chartItem.x,
      barRods: [
        BarChartRodData(
          toY: chartItem.y,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    )).toList();
  }
}

