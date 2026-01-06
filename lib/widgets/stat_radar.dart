import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class StatRadar extends StatelessWidget {
  final List<int> values; // [str, vit, agi, int, sen]
  final int maxVal;

  const StatRadar({super.key, required this.values, this.maxVal = 100});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: RadarChart(
        RadarChartData(
          dataSets: [
            RadarDataSet(
              fillColor: Colors.cyanAccent.withOpacity(0.2),
              borderColor: Colors.cyanAccent,
              entryRadius: 2,
              dataEntries: values
                  .map((e) => RadarEntry(value: e.toDouble()))
                  .toList(),
              borderWidth: 2,
            ),
          ],
          radarBackgroundColor: Colors.transparent,
          borderData: FlBorderData(show: false),
          radarBorderData: const BorderSide(color: Colors.white10),
          titlePositionPercentageOffset: 0.2,
          titleTextStyle: GoogleFonts.shareTechMono(
            color: Colors.grey,
            fontSize: 10,
          ),
          tickCount: 1,
          ticksTextStyle: const TextStyle(color: Colors.transparent),
          tickBorderData: const BorderSide(color: Colors.transparent),
          gridBorderData: const BorderSide(color: Colors.white12, width: 1),
          getTitle: (index, angle) {
            const titles = ['STR', 'VIT', 'AGI', 'INT', 'SEN'];
            return RadarChartTitle(text: titles[index]);
          },
        ),
      ),
    );
  }
}
