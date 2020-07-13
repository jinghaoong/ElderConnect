import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:mobile/pages/blood_pressure.dart';

class BloodPressureChart extends StatefulWidget {
  @override
  _BloodPressureChartState createState() => _BloodPressureChartState();
}

class ChartElement {
  final int reading;
  final String datetime;

  ChartElement(this.reading, this.datetime);

  @override
  toString() => '$reading $datetime';
}

class _BloodPressureChartState extends State<BloodPressureChart> {
  Future<List<BloodPressure>> _bloodPressureFuture;

  @override
  void initState() {
    super.initState();
    _bloodPressureFuture = fetchBloodPressure(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Pressure Chart', style: TextStyle(fontSize: 22.0)),
        centerTitle: true,
        backgroundColor: Colors.grey[700],
      ),
      body: Center(
        child: FutureBuilder<List<BloodPressure>>(
          future: _bloodPressureFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              int length = snapshot.data.length;
              List<ChartElement> systolic = List();
              List<ChartElement> diastolic = List();

              for (int i = 0; i < length; i++) {
                BloodPressure bp = snapshot.data[i];
                String datetime = bp.date + '\n' + bp.time;
                systolic.add(ChartElement(bp.systolic, datetime));
                diastolic.add(ChartElement(bp.diastolic, datetime));
              }

              var series = [
                new charts.Series(
                  id: 'Systolic',
                  domainFn: (ChartElement element, _) => element.datetime,
                  measureFn: (ChartElement element, _) => element.reading,
                  data: systolic,
                ),
                new charts.Series(
                  id: 'Diastolic',
                  colorFn: (_, __) =>
                      charts.ColorUtil.fromDartColor(Colors.yellow[400]),
                  fillColorFn: (_, __) =>
                      charts.ColorUtil.fromDartColor(Colors.yellow[400]),
                  domainFn: (ChartElement element, _) => element.datetime,
                  measureFn: (ChartElement element, _) => element.reading,
                  data: diastolic,
                )
              ];

              var bpChart =  charts.BarChart(
                series,
                animate: true,

                // Assign custom style for domain axis (datetime)
                domainAxis: charts.OrdinalAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(
                    // Tick and Label styling
                    labelStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.white,
                    )
                  )
                ),

                // Assign custom style for measure axis (reading)
                primaryMeasureAxis: charts.NumericAxisSpec(
                  renderSpec: charts.GridlineRendererSpec(
                    // Tick and Label styling
                    labelStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.white,
                    )
                  )
                ),
                barGroupingType: charts.BarGroupingType.grouped,
                vertical: false,
                behaviors: [charts.SeriesLegend()],
              );

              return Padding(
                padding: EdgeInsets.fromLTRB(5.0, 0, 10.0, 10.0),
                child: bpChart
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          }
        )
      ),
    );
  }
}
