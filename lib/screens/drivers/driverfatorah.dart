import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class DeliveryReceiptfordriver extends StatefulWidget {
  final List<Map<String, dynamic>> userOrders;

  DeliveryReceiptfordriver({required this.userOrders});

  @override
  State<DeliveryReceiptfordriver> createState() => _DeliveryReceiptState();
}

class _DeliveryReceiptState extends State<DeliveryReceiptfordriver> {



  
  @override
  void initState() {
    super.initState();
    getFont();
  }

  pw.Font? font;
ByteData? imageBytes;
  getFont() async {
    var f = await PdfGoogleFonts.tajawalBold();

    setState(() {
      font = f;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Receipt'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () => _printDocument(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              SizedBox(height: 16),
              _buildCustomerInfo(),
              SizedBox(height: 16),
              _buildDeliveryTable(),
              SizedBox(height: 16),
              _buildTotalSection(),
              SizedBox(height: 16),
              _buildFooterNote(),
            ],
          ),
        ),
      ),
    );
  }

  // ... (keep all the existing _build methods as they are)
  Future<void> _printDocument(BuildContext context) async {
    final pdf = pw.Document();
final image = await imageFromAssetBundle('assets/alilogo.png');

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
pw.Row(
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Durub',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text('Express delivery'),
            ],
          ),
        ),
        pw.SizedBox(
height: 200,         
 child:      pw.Image(image),

        ),

        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'دروب',
                textDirection: pw.TextDirection.rtl, // Right to left direction

                style: pw.TextStyle(
                    fontSize: 18, fontWeight: pw.FontWeight.bold, font: font),
              ),
              pw.Text(
                'لخدمات التوصيل',
                textDirection: pw.TextDirection.rtl, // Right to left direction

                style: pw.TextStyle(font: font),
              ),
            ],
          ),
        ),
      ],
    ),
                  pw.SizedBox(height: 16),
              _buildPdfCustomerInfo(),
              pw.SizedBox(height: 16),
              _buildPdfDeliveryTable(),
              pw.SizedBox(height: 16),
              _buildPdfTotalSection(),
              pw.SizedBox(height: 16),
              _buildPdfFooterNote(),
            ];
          
        },
      ),
    );

    final bytes = await pdf.save();
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => bytes,
    );
  }

  pw.Widget _buildPdfHeader() {
    print(imageBytes!.buffer.asUint8List());
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Durub',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text('Express delivery'),
            ],
          ),
        ),
            pw.Container(
              decoration: pw.BoxDecoration(
                image: pw.DecorationImage(
                  image: pw.MemoryImage(
               imageBytes!.buffer.asUint8List(),
                  ),  
                )
              )
             ),

        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'دروب',
                textDirection: pw.TextDirection.rtl, // Right to left direction

                style: pw.TextStyle(
                    fontSize: 18, fontWeight: pw.FontWeight.bold, font: font),
              ),
              pw.Text(
                'لخدمات التوصيل',
                textDirection: pw.TextDirection.rtl, // Right to left direction

                style: pw.TextStyle(font: font),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPdfCustomerInfo() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          padding: pw.EdgeInsets.all(8),
          color: PdfColors.grey300,
          child: pw.Text(
            'كشف حساب السائق',
            textDirection: pw.TextDirection.rtl, // Right to left direction

            style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),

            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text(
                  'العميل: دروب دليفري',
                  textDirection:
                      pw.TextDirection.rtl, // Right to left direction

                  style: pw.TextStyle(font: font),
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text(
                  'رقم الهاتف: 0788050049',
                  textDirection:
                      pw.TextDirection.rtl, // Right to left direction

                  style: pw.TextStyle(font: font),
                ),
              ),
            ]),
            pw.TableRow(children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text(
                  'العنوان: جبل النصر حي عدن',
                  textDirection:
                      pw.TextDirection.rtl, // Right to left direction

                  style: pw.TextStyle(font: font),
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text(
                  'ملاحظات:',
                  textDirection:
                      pw.TextDirection.rtl, // Right to left direction

                  style: pw.TextStyle(font: font),
                ),
              ),
            ]),
          ],
        ),
      ],
    );
  }

pw.Widget _buildPdfDeliveryTable() {
  return pw.Table(
    border: pw.TableBorder.all(),
    columnWidths: {
      0: pw.FlexColumnWidth(0.5),
      1: pw.FlexColumnWidth(2),
      2: pw.FlexColumnWidth(2),
      3: pw.FlexColumnWidth(1),
      4: pw.FlexColumnWidth(1),
      5: pw.FlexColumnWidth(1),
      6: pw.FlexColumnWidth(1),
      7: pw.FlexColumnWidth(2),
    },
    children: [
      pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.grey300),
        children: [
          _buildPdfTableHeader('م'),
          _buildPdfTableHeader('الباركود'),
          _buildPdfTableHeader('المرسل اليه'),
          _buildPdfTableHeader('التاريخ'),
          _buildPdfTableHeader('القيمة'),
          _buildPdfTableHeader('اجور توصيل'),
          _buildPdfTableHeader('الحالة'),
          _buildPdfTableHeader('ملاحظات'),
        ],
      ),
      ...widget.userOrders.asMap().entries.map((entry) {
        final index = entry.key;
        final order = entry.value;
        return pw.TableRow(
          children: [
            _buildPdfTableCell((index + 1).toString()),
            _buildPdfTableCell(order['رقم الطلب']?.toString() ?? ''),
            _buildPdfTableCell(order['اسم العميل'] ?? ''),
            _buildPdfTableCell(order['timestamp']?.toString() ?? ''),
            _buildPdfTableCell(order['السعر']?.toString()??""),
            _buildPdfTableCell(order['deliveryCost']?.toString() ?? ''),
            _buildPdfTableCell(order['status'] ?? ''),
            _buildPdfTableCell(order['الملاحظات']?? ''),
          ],
        );
      }).toList(),
    ],
  );
}  pw.Widget _buildPdfTableHeader(String text) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textDirection: pw.TextDirection.rtl, // Right to left direction

        style: pw.TextStyle(font: font),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildPdfTableCell(String text) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(8),
      child: pw.Text(text, textAlign: pw.TextAlign.center),
    );
  }

  pw.Widget _buildPdfTotalSection() {
    double totalValue =
        widget.userOrders.fold(0, (sum, order) => sum + (order['السعر'] ?? 0));
    double totalDeliveryFees = widget.userOrders
        .fold(0, (sum, order) => sum + (order['deliveryCost'] ?? 0));
    double netTotal = totalValue - totalDeliveryFees;

    return pw.Container(
      color: PdfColors.grey300,
      padding: pw.EdgeInsets.all(8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Text(
            'اجمالي قيمة الشحنات: $totalValue',
            textDirection: pw.TextDirection.rtl, // Right to left direction

            style: pw.TextStyle(font: font),
          ),
          pw.Text(
            'إجمالي أجور التوصيل: $totalDeliveryFees',
            textDirection: pw.TextDirection.rtl, // Right to left direction

            style: pw.TextStyle(font: font),
          ),
          pw.Text(
            'الصافي: $netTotal',
            textDirection: pw.TextDirection.rtl, // Right to left direction

            style: pw.TextStyle(font: font),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfFooterNote() {
    return pw.Text(
      'يعتبر السند و الكشف صحيحاً ما لم يتم اشعار المؤسسة خطياً بخلاف ذلك خلال خمسة عشر يوماً من تاريخ الكشف وبعد ذلك سيتم اتلاف السند والكشف',
                  textDirection:
                      pw.TextDirection.rtl, // Right to left direction

                  style: pw.TextStyle(font: font, fontSize: 19),
      textAlign: pw.TextAlign.center,
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Durub',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Express delivery'),
            ],
          ),
        ),
        Image.asset('assets/alilogo.png', height: 200),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'دروب',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('لخدمات التوصيل'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          color: Colors.grey[300],
          child: Text(
            'كشف حساب السائق',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'العميل: دروب دليفري',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('رقم الهاتف: 0788050049'),
              ),
            ]),
            TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('العنوان: جبل النصر حي عدن'),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('ملاحظات:'),
              ),
            ]),
          ],
        ),
      ],
    );
  }

Widget _buildDeliveryTable() {
  return Table(
    border: TableBorder.all(),
    columnWidths: {
      0: FlexColumnWidth(0.5),
      1: FlexColumnWidth(2),
      2: FlexColumnWidth(2),
      3: FlexColumnWidth(1),
      4: FlexColumnWidth(1),
      5: FlexColumnWidth(1),
      6: FlexColumnWidth(1),
      7: FlexColumnWidth(2),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(color: Colors.grey[300]),
        children: [
          _buildTableHeader('م'),
          _buildTableHeader('الباركود'),
          _buildTableHeader('المرسل اليه'),
          _buildTableHeader('التاريخ'),
          _buildTableHeader('القيمة'),
          _buildTableHeader('اجور توصيل'),
          _buildTableHeader('الحالة'),
          _buildTableHeader('ملاحظات'),
        ],
      ),
      ...widget.userOrders.asMap().entries.map((entry) {
        final index = entry.key;
        final order = entry.value;
        return TableRow(
          children: [
            _buildTableCell((index + 1).toString()),
            _buildTableCell(order['رقم الطلب'] ??"" ),
            _buildTableCell(order['اسم العميل'] ?? ''),
            _buildTableCell(order['timestamp']?.toString() ?? ''),
            _buildTableCell(order['السعر']?.toString() ?? ''),
            _buildTableCell(order['deliveryCost']?.toString() ?? ''),
            _buildTableCell(order['status'] ?? ''),
            _buildTableCell(order['الملاحظات'] ?? ''),
          ],
        );
      }).toList(),
    ],
  );
}
  Widget _buildTableHeader(String text) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(text, textAlign: TextAlign.center),
    );
  }

  Widget _buildTotalSection() {
    double totalValue = widget.userOrders.fold(0, (sum, order) => sum + ((order['السعر']??0.0)
)  );
    double totalDeliveryFees = widget.userOrders
        .fold(0, (sum, order) => sum + (order['deliveryCost'] ?? 0));
    double netTotal = totalValue - totalDeliveryFees;

    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('اجمالي قيمة الشحنات: $totalValue'),
          Text('إجمالي أجور التوصيل: $totalDeliveryFees'),
          Text('الصافي: $netTotal'),
        ],
      ),
    );
  }

  Widget _buildFooterNote() {
    return Text(
      'يعتبر السند و الكشف صحيحاً ما لم يتم اشعار المؤسسة خطياً بخلاف ذلك خلال خمسة عشر يوماً من تاريخ الكشف وبعد ذلك سيتم اتلاف السند والكشف',
      style: TextStyle(fontSize: 12),
      textAlign: TextAlign.center,
    );
  }
}
