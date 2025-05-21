import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AmonakDashboardScreen extends StatefulWidget {
  const AmonakDashboardScreen({super.key});

  @override
  State<AmonakDashboardScreen> createState() => _AmonakDashboardScreenState();
}

class _AmonakDashboardScreenState extends State<AmonakDashboardScreen> {
  int _selectedMonthIndex = 2; // Index for November

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Text
              const Text(
                'Ces statistiques vous aide à mieux connaitre votre impact et\naméliorer votre stratégie de croissance sur Amonak.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Sales Evolution Card
              _buildSalesEvolutionCard(),
              const SizedBox(height: 20),

              // Store Visits Card
              _buildStoreVisitsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesEvolutionCard() {
    final List<String> months = ['Sep', 'Oct', 'Nov', 'Dec', 'Jan'];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vente',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              'Évolution des ventes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  '11,756',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_drop_up,
                        color: Colors.green,
                        size: 24,
                      ),
                      Text(
                        '23%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150, // Height for the sales chart
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: months.length - 1.toDouble(),
                  minY: 0,
                  maxY: 12000, // Adjust based on your actual data
                  // lineTouchData: LineTouchData(
                  //   touchTooltipData: FlTouchTooltipData(
                  //     tooltipBgColor: Colors.blueAccent,
                  //     getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  //       return touchedBarSpots.map((barSpot) {
                  //         final flSpot = barSpot.flSpot;
                  //         return LineTooltipItem(
                  //           '${flSpot.y.toInt()}',
                  //           const TextStyle(color: Colors.white),
                  //         );
                  //       }).toList();
                  //     },
                  //   ),
                  //   handleBuiltInTouches: true,
                  // ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        // Example data, replace with your actual sales data
                        FlSpot(0, 8000), // Sep
                        FlSpot(1, 9500), // Oct
                        FlSpot(2, 11756), // Nov - highlighted
                        FlSpot(3, 10500), // Dec
                        FlSpot(4, 9000), // Jan
                      ],
                      isCurved: true,
                      color: const Color(0xFF5A6BE3), // Line color
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          if (index == _selectedMonthIndex) {
                            return FlDotCirclePainter(
                              radius: 6,
                              color: const Color(0xFF5A6BE3),
                              strokeColor: Colors.white,
                              strokeWidth: 3,
                            );
                          }
                          return FlDotCirclePainter(
                            radius: 0, // Hide other dots
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF5A6BE3).withOpacity(0.3),
                            const Color(0xFF5A6BE3).withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(months.length, (index) {
                bool isSelected = index == _selectedMonthIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMonthIndex = index;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF5A6BE3)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      months[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreVisitsCard() {
    final List<String> dates = [
      '1 Oct',
      '3 Oct',
      '7 Oct',
      '10 Oct',
      '14 Oct',
      '20 Oct',
      '23 Oct',
      '27 Oct',
      '31 Oct'
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Visite de la boutique',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildLegendItem(const Color(0xFF5A6BE3), 'Objectif'),
                const SizedBox(width: 15),
                _buildLegendItem(const Color(0xFFC7B8F9), 'Visiteur'),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200, // Height for the visits chart
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles()),
                    topTitles: const AxisTitles(sideTitles: SideTitles()),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          // Display date labels for every 2nd or 3rd spot to avoid clutter
                          if (value.toInt() % 2 == 0) {
                            return SideTitleWidget(
                              meta: meta,
                              space: 8.0,
                              child: Text(
                                dates[value.toInt()],
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          String text;
                          if (value == 0) {
                            text = '0';
                          } else if (value == 1000) {
                            text = '1k';
                          } else if (value == 2000) {
                            text = '2k';
                          } else if (value == 3000) {
                            text = '3k';
                          } else if (value == 4000) {
                            text = '4k';
                          } else {
                            return const Text('');
                          }
                          return Text(text,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.left);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: dates.length - 1.toDouble(),
                  minY: 0,
                  maxY: 4000,
                  lineBarsData: [
                    // Objectif line
                    LineChartBarData(
                      spots: const [
                        // Example data for Objectif
                        FlSpot(0, 1500),
                        FlSpot(1, 2000),
                        FlSpot(2, 1800),
                        FlSpot(3, 2500),
                        FlSpot(4, 3000),
                        FlSpot(5, 2700),
                        FlSpot(6, 3200),
                        FlSpot(7, 2800),
                        FlSpot(8, 3500),
                      ],
                      isCurved: true,
                      color: const Color(0xFF5A6BE3),
                      barWidth: 2,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: const Color(0xFF5A6BE3),
                            strokeColor: Colors.white,
                            strokeWidth: 2,
                          );
                        },
                      ),
                    ),
                    // Visiteur line
                    LineChartBarData(
                      spots: const [
                        // Example data for Visiteur
                        FlSpot(0, 500),
                        FlSpot(1, 1200),
                        FlSpot(2, 800),
                        FlSpot(3, 1500),
                        FlSpot(4, 2000),
                        FlSpot(5, 1000),
                        FlSpot(6, 600),
                        FlSpot(7, 1800),
                        FlSpot(8, 2500),
                      ],
                      isCurved: true,
                      color: const Color(0xFFC7B8F9),
                      barWidth: 2,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: const Color(0xFFC7B8F9),
                            strokeColor: Colors.white,
                            strokeWidth: 2,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
