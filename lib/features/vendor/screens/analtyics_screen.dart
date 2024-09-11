import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/utils/loader.dart';
import '../models/sales.dart';
import '../services/vendor_services.dart';
import '../widgets/category_products_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final VendorServices _vendorServices = VendorServices();
  double? _totalSales;
  List<Sales>? _earnings;

  @override
  void initState() {
    super.initState();
    _fetchEarnings();
  }

  Future<void> _fetchEarnings() async {
    final earningData = await _vendorServices.getEarnings(context);
    setState(() {
      _totalSales = earningData['totalEarnings'];
      _earnings = earningData['sales'];
    });
  }
  getEarnings() async {
    var earningData = await _vendorServices.getEarnings(context);
    _totalSales = earningData['totalEarnings'];
    _earnings = earningData['sales'];
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_earnings == null || _totalSales == null) {
      return const Center(child: Loader());
    }

    return RefreshIndicator(
      onRefresh: _fetchEarnings,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTotalSalesCard(),
              const SizedBox(height: 24),
              buildChart(context),
              const SizedBox(height: 24),
              _buildSalesChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChart(BuildContext context) {
    return _earnings == null || _totalSales == null
        ? const Loader()
        : Column(
      children: [
        SizedBox(
          height: 250,
          child: CategoryProductsChart(seriesList: [
            charts.Series(
              id: 'Sales',
              data: _earnings!,
              domainFn: (Sales sales, _) => sales.label,
              measureFn: (Sales sales, _) => sales.earning,
            ),
          ]),
        )
      ],
    );
  }

  Widget _buildTotalSalesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Sales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${_totalSales!.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales Trend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(_createLineChartData()),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _createLineChartData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 40,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  '\$${value.toInt()}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 60,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < _earnings!.length) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: RotatedBox(
                    quarterTurns: 3, // Rotate labels to fit better
                    child: Text(
                      _earnings![index].label,
                      style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey, width: 1),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: _earnings!
              .asMap()
              .entries
              .map((entry) => FlSpot(entry.key.toDouble(), entry.value.earning))
              .toList(),
          isCurved: true,
          color: Colors.blue,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.blue.withOpacity(0.2),
          ),
        ),
      ],
    );
  }



}