import 'package:flutter/material.dart';

class DriversTrackingTable extends StatefulWidget {
  @override
  _DriversTrackingTableState createState() => _DriversTrackingTableState();
}

class _DriversTrackingTableState extends State<DriversTrackingTable> {
  List<DriverData> drivers = [
    DriverData(
      name: "مؤنس المصري",
      totalParcels: 3,
      delivered: 0,
      pending: 3,
      returned: 0,
    ),
    DriverData(
      name: "وسام القيسي",
      totalParcels: 3,
      delivered: 0,
      pending: 3,
      returned: 0,
    ),
    // Add more sample data here
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('تقرير السائقين'),
          backgroundColor: Colors.orange,
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                // Add driver logic
              },
              icon: Icon(Icons.add),
              label: Text('إضافة طرد'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(label: Text('اسم السائق')),
                DataColumn(label: Text('بانتظار التسليم')),
                DataColumn(label: Text('مرتجعة')),
                DataColumn(label: Text('تم تسليمها')),
                DataColumn(label: Text('تم تسليمها بشكل جزئي')),
                DataColumn(label: Text('معلقة')),
                DataColumn(label: Text('تم توصيلها')),
                DataColumn(label: Text('لم يتم توصيلها')),
                DataColumn(label: Text('طرود غير محددة')),
                DataColumn(label: Text('مجموع التحصيلات')),
                DataColumn(label: Text('تقرير التحصيل')),
              ],
              rows: drivers.map((driver) {
                return DataRow(
                  cells: [
                    DataCell(Text(driver.name)),
                    DataCell(Text(driver.totalParcels.toString())),
                    DataCell(Text(driver.returned.toString())),
                    DataCell(Text(driver.delivered.toString())),
                    DataCell(Text('0')),
                    DataCell(Text('0')),
                    DataCell(Text('0')),
                    DataCell(Text('0')),
                    DataCell(Text(driver.pending.toString())),
                    DataCell(Text('0')),
                    DataCell(Text('0')),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class DriverData {
  final String name;
  final int totalParcels;
  final int delivered;
  final int pending;
  final int returned;

  DriverData({
    required this.name,
    required this.totalParcels,
    required this.delivered,
    required this.pending,
    required this.returned,
  });
}

// Usage example
void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.orange,
      scaffoldBackgroundColor: Colors.grey[900],
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: MaterialStateProperty.all(Colors.orange),
        dataRowColor: MaterialStateProperty.all(Colors.grey[800]),
      ),
    ),
    home: DriversTrackingTable(),
  ));
}