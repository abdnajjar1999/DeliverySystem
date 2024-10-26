import 'package:flutter/material.dart';

class TrainingRecord {
  final String id;
  final String title;
  final String status;
  final String startDate;
  final String endDate;
  final String type;
  final int progress;
  final String description;

  TrainingRecord({
    required this.id,
    required this.title,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.progress,
    required this.description,
  });
}

class DarkThemeDataTable extends StatefulWidget {
  final List<TrainingRecord> records;

  const DarkThemeDataTable({
    Key? key,
    required this.records,
  }) : super(key: key);

  @override
  State<DarkThemeDataTable> createState() => _DarkThemeDataTableState();
}

class _DarkThemeDataTableState extends State<DarkThemeDataTable> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        cardColor: const Color(0xFF1E1E1E),
        dividerColor: Colors.grey[800],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(const Color(0xFF2D2D2D)),
            dataRowColor: MaterialStateProperty.all(const Color(0xFF1E1E1E)),
            columnSpacing: 20,
            horizontalMargin: 20,
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Title')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Start Date')),
              DataColumn(label: Text('End Date')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Progress')),
              DataColumn(label: Text('Description')),
            ],
            rows: widget.records.map((record) {
              return DataRow(
                cells: [
                  DataCell(Text(record.id)),
                  DataCell(Text(record.title)),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2D2D),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        record.status,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  DataCell(Text(record.startDate)),
                  DataCell(Text(record.endDate)),
                  DataCell(Text(record.type)),
                  DataCell(
                    LinearProgressIndicator(
                      value: record.progress / 100,
                      backgroundColor: Colors.grey[800],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  DataCell(Text(record.description)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// Example usage:
class TrainingRecordsScreen extends StatelessWidget {
  TrainingRecordsScreen({Key? key}) : super(key: key);

  final List<TrainingRecord> dummyRecords = [
    TrainingRecord(
      id: 'TR001',
      title: 'Training Course 1',
      status: 'In Progress',
      startDate: '21/10/2024',
      endDate: '25/10/2024',
      type: 'Online',
      progress: 75,
      description: 'Description of training course',
    ),
    // Add more records as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Training Records'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DarkThemeDataTable(records: dummyRecords),
      ),
    );
  }
}
