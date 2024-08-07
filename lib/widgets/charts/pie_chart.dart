
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:indieflow/models/charts/pie_chart_data_item.dart';
import 'package:indieflow/utils/extensions.dart';

class PieStyleChartWidget extends StatefulWidget {

  final List<PieChartDataItem> chartItems;
  const PieStyleChartWidget({super.key, required this.chartItems});

  @override
  State<StatefulWidget> createState() => _PieStyleChartWidgetState();
}

class _PieStyleChartWidgetState extends State<PieStyleChartWidget> {
  
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        margin: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: AppColors.itemsBackground,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Row(
        children: [
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.chartItems.map((chartItem) {
              return Indicator(
                color: chartItem.color,
                text: chartItem.title,
                isSquare: true,
              );
            }).toList(),
          ),
          const SizedBox(width: 28),
        ],
      ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return widget.chartItems.map((chartItem) {
      final isTouched = widget.chartItems.indexOf(chartItem) == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 90.0 : 70.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return PieChartSectionData(
        color: chartItem.color,
        value: chartItem.value.toDouble(),
        title: '${chartItem.value}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    }).toList();
  }
}

class Indicator extends StatelessWidget {

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}