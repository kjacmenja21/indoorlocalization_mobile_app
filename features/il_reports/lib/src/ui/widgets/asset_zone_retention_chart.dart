import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:il_core/il_helpers.dart';
import 'package:il_reports/src/models/asset_zone_retention_data.dart';

class AssetZoneRetentionChart extends StatelessWidget {
  final AssetZoneRetentionReportData data;

  const AssetZoneRetentionChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RetentionTable(data),
        const SizedBox(height: 20),
        _RetentionChart(data),
      ],
    );
  }
}

class _RetentionTable extends StatelessWidget {
  final AssetZoneRetentionReportData data;

  const _RetentionTable(this.data);

  @override
  Widget build(BuildContext context) {
    var dataTable = DataTable(
      horizontalMargin: 0,
      columnSpacing: 20,
      columns: const [
        DataColumn(label: Text('Zone')),
        DataColumn(label: Text('Percentage')),
        DataColumn(label: Text('Retention')),
      ],
      rows: data.zoneRetentionData.map((e) => getDataRow(e)).toList(),
    );

    return Row(
      children: [
        Expanded(
          child: dataTable,
        ),
      ],
    );
  }

  DataRow getDataRow(AssetZoneRetention zone) {
    var percentage = '${(zone.percentage * 100).toStringAsFixed(1)}%';
    var period = DateFormats.formatDuration(zone.retention);

    return DataRow(
      cells: [
        DataCell(_ZoneIndicator(
          color: zone.color,
          name: zone.zoneName,
        )),
        DataCell(Text(percentage)),
        DataCell(Text(period)),
      ],
    );
  }
}

class _RetentionChart extends StatefulWidget {
  final AssetZoneRetentionReportData data;

  const _RetentionChart(this.data);

  @override
  State<_RetentionChart> createState() => _RetentionChartState();
}

class _RetentionChartState extends State<_RetentionChart> {
  int selectedSectionIndex = -1;

  void onPieTouch(FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
    setState(() {
      if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
        selectedSectionIndex = -1;
        return;
      }
      selectedSectionIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: onPieTouch,
          ),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 50,
          startDegreeOffset: -90,
          sections: getSectionData(),
        ),
      ),
    );
  }

  List<PieChartSectionData> getSectionData() {
    var zoneRetentionData = widget.data.zoneRetentionData;

    return List.generate(zoneRetentionData.length, (index) {
      var e = zoneRetentionData[index];

      var isSelected = index == selectedSectionIndex;
      var fontSize = isSelected ? 25.0 : 16.0;
      var radius = isSelected ? 60.0 : 50.0;
      var title = '${(e.percentage * 100).toStringAsFixed(1)}%';

      return PieChartSectionData(
        value: e.percentage,
        color: e.color,
        title: title,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
        ),
      );
    });
  }
}

class _ZoneIndicator extends StatelessWidget {
  final Color color;
  final String name;

  const _ZoneIndicator({
    required this.color,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(),
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Flexible(
          child: Text(name),
        )
      ],
    );
  }
}
