import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/common/custom_dropdown_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

@RoutePage()
class TrialView extends ConsumerStatefulWidget {
  const TrialView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TrialViewState();
}

class _TrialViewState extends ConsumerState<TrialView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akçadağ MW İzleme',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      home: const EnergyMonitoringScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EnergyMonitoringScreen extends StatelessWidget {
  const EnergyMonitoringScreen({Key? key}) : super(key: key);

  // Sample data for the application
  final List<Map<String, dynamic>> dummyData = const [
    {
      'unit': 'Ünite 1',
      'hourlyData': [
        {'time': '10:00', 'consumption': 48.0},
        {'time': '11:00', 'consumption': 52.0},
        {'time': '12:00', 'consumption': 59.0},
      ],
      'totalDaily': 159.0,
    },
    {
      'unit': 'Ünite 2',
      'hourlyData': [
        {'time': '10:00', 'consumption': 42.0},
        {'time': '11:00', 'consumption': 38.0},
        {'time': '12:00', 'consumption': 45.0},
      ],
      'totalDaily': 125.0,
    },
    {
      'unit': 'Ünite 3',
      'hourlyData': [
        {'time': '10:00', 'consumption': 85.0},
        {'time': '11:00', 'consumption': 89.0},
        {'time': '12:00', 'consumption': 92.0},
      ],
      'totalDaily': 266.0,
    },
    {
      'unit': 'Ünite 4',
      'hourlyData': [
        {'time': '10:00', 'consumption': 35.0},
        {'time': '11:00', 'consumption': 41.0},
        {'time': '12:00', 'consumption': 38.0},
      ],
      'totalDaily': 114.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final totalConsumption = dummyData.fold<double>(
      0,
      (sum, unit) => sum + unit['totalDaily'],
    );

    final highestUnit =
        dummyData.reduce((a, b) => a['totalDaily'] > b['totalDaily'] ? a : b);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device Cards Section
            _buildSectionHeader('Cihaz Bilgileri'),
            const SizedBox(height: 12),
            ...dummyData.map((unitData) => _buildDeviceCard(unitData)),

            const SizedBox(height: 24),

            // Total Summary Card
            _buildTotalSummaryCard(totalConsumption),

            const SizedBox(height: 24),

            // Graph Cards Section
            _buildSectionHeader('İstatistikler'),
            const SizedBox(height: 12),
            _buildGraphCards(),

            const SizedBox(height: 24),

            // Additional Info Cards
            _buildSectionHeader('Sistem Bilgileri'),
            const SizedBox(height: 12),
            _buildInfoCards(highestUnit),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget: App Bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Akçadağ MW İzleme',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1A1A1A),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.electric_bolt,
          color: Colors.white,
          size: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {},
        ),
      ],
    );
  }

  // Widget: Section Header
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  // Widget: Device Card
  Widget _buildDeviceCard(Map<String, dynamic> unitData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unit Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    unitData['unit'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'AKTİF',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),

              // Hourly Data
              Column(
                children:
                    (unitData['hourlyData'] as List).map<Widget>((hourData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          hourData['time'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        Text(
                          '${hourData['consumption']} MW',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 12),
              const Divider(color: Color(0xFFE0E0E0)),
              const SizedBox(height: 8),

              // Total Daily Usage
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Günlük Üretim',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    '${unitData['totalDaily']} MW',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget: Total Summary Card
  Widget _buildTotalSummaryCard(double totalConsumption) {
    return Card(
      elevation: 4,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Günlük Toplam Tüketim',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${totalConsumption.toStringAsFixed(0)} MW',
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Düne göre %12↑',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget: Graph Cards
  Widget _buildGraphCards() {
    return Column(
      children: [
        // Daily Usage Graph
        Card(
          elevation: 2,
          surfaceTintColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Günlük Kullanım Grafiği',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}MW',
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const hours = [
                                '10:00',
                                '11:00',
                                '12:00',
                                '13:00',
                                '14:00'
                              ];
                              if (value.toInt() < hours.length) {
                                return Text(
                                  hours[value.toInt()],
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 210),
                            FlSpot(1, 220),
                            FlSpot(2, 234),
                            FlSpot(3, 245),
                            FlSpot(4, 238),
                          ],
                          isCurved: true,
                          color: const Color(0xFF2196F3),
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xFF2196F3).withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Monthly Usage Graph
        Card(
          elevation: 2,
          surfaceTintColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aylık Üretim Grafiği',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barGroups: [
                        BarChartGroupData(x: 0, barRods: [
                          BarChartRodData(
                              toY: 6500, color: const Color(0xFF2196F3))
                        ]),
                        BarChartGroupData(x: 1, barRods: [
                          BarChartRodData(
                              toY: 7200, color: const Color(0xFF2196F3))
                        ]),
                        BarChartGroupData(x: 2, barRods: [
                          BarChartRodData(
                              toY: 6800, color: const Color(0xFF2196F3))
                        ]),
                        BarChartGroupData(x: 3, barRods: [
                          BarChartRodData(
                              toY: 7500, color: const Color(0xFF2196F3))
                        ]),
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const months = ['Jan', 'Feb', 'Mar', 'Apr'];
                              return Text(
                                months[value.toInt()],
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${(value / 1000).toStringAsFixed(1)}K',
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: true),
                      gridData: const FlGridData(show: true),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget: Additional Info Cards
  Widget _buildInfoCards(Map<String, dynamic> highestUnit) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Toplam Kapasite',
                '1,000 MW',
                Icons.electrical_services,
                const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                'Anlık Kapasite',
                '892 MW',
                Icons.flash_on,
                const Color(0xFFFF9800),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          'En Yükek Üretim Ünitesi',
          '${highestUnit['unit']} - ${highestUnit['totalDaily']} MW',
          Icons.trending_up,
          const Color(0xFFF44336),
        ),
      ],
    );
  }

  // Widget: Individual Info Card
  Widget _buildInfoCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
