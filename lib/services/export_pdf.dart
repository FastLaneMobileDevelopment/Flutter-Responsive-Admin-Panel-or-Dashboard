import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';

class PDFReport extends StatefulWidget {
  final trap;

  PDFReport(this.trap);

  @override
  State<PDFReport> createState() => _PDFReportState();
}

class _PDFReportState extends State<PDFReport> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: PdfPreview(
          build: (format) =>generateReport(format, widget.trap)
          ),
    );
  }
}



Future<Uint8List> generateReport(
    PdfPageFormat pageFormat, YupcityTrapPoi trap) async {
  const tableHeaders = ['Centro', 'Nª de usos', 'Tiempo de uso', 'Result'];

  const dataTable = [
    ['Phone', 80, 95],
    ['Internet', 250, 230],
    ['Electricity', 300, 375],
    ['Movies', 85, 80],
    ['Food', 300, 350],
    ['Fuel', 650, 550],
    ['Insurance', 250, 310],
  ];

  // Some summary maths
  final budget = dataTable
      .map((e) => e[1] as num)
      .reduce((value, element) => value + element);
  final expense = dataTable
      .map((e) => e[2] as num)
      .reduce((value, element) => value + element);

  const baseColor = PdfColors.blue;

  // Create a PDF document.
  final document = pw.Document();

  final theme = pw.ThemeData.withFont(
    base: await PdfGoogleFonts.openSansRegular(),
    bold: await PdfGoogleFonts.openSansBold(),
  );


  // Left curved line chart
  final chart2 = pw.Container(
      height: 300,
      child:  pw.Chart(
    right: pw.ChartLegend(),
    grid: pw.CartesianGrid(
      xAxis: pw.FixedAxis([0, 1, 2, 3, 4, 5, 6]),
      yAxis: pw.FixedAxis(
        [0, 200, 400, 600],
        divisions: true,
      ),
    ),
    datasets: [
      pw.LineDataSet(
        legend: 'Tiempo de uso',
        drawSurface: true,
        isCurved: true,
        drawPoints: false,
        color: baseColor,
        data: List<pw.LineChartValue>.generate(
          dataTable.length,
              (i) {
            final value = dataTable[i][2] as num;
            return pw.LineChartValue(i.toDouble(), value.toDouble());
          },
        ),
      ),
    ],
  ));

  // Data table
  final table = pw.Table.fromTextArray(
    border: null,
    headers: tableHeaders,
    data: List<List<dynamic>>.generate(
      dataTable.length,
          (index) => <dynamic>[
        dataTable[index][0],
        dataTable[index][1],
        dataTable[index][2],
        (dataTable[index][1] as num) - (dataTable[index][2] as num),
      ],
    ),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontWeight: pw.FontWeight.bold,
    ),
    headerDecoration: const pw.BoxDecoration(
      color: baseColor,
    ),
    rowDecoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          color: baseColor,
          width: .5,
        ),
      ),
    ),
    cellAlignment: pw.Alignment.centerRight,
    cellAlignments: {0: pw.Alignment.centerLeft},
  );

  // Add page to the PDF
  document.addPage(
    pw.Page(
      pageFormat: pageFormat,
      theme: theme,
      build: (context) {
        // Page layout
        return pw.Column(
          children: [
            pw.Text('Centro la Maquinista',
                style: const pw.TextStyle(
                  color: baseColor,
                  fontSize: 40,
                )),
            pw.Divider(thickness: 4),
            pw.SizedBox(height: 30),
            pw.Divider(),
            pw.Container( child: chart2),
            pw.SizedBox(height: 40),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(width: 10),
                pw.Expanded(
                    child: pw.Column(
                        children: [
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        padding: const pw.EdgeInsets.only(bottom: 10),
                        child: pw.Text(
                          'General',
                          style: const pw.TextStyle(
                            color: baseColor,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      pw.Text(
                        'Creado el: 12-12-12',
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.Text(
                        'Nº de usos total: 55 veces',
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.Text(
                        'Tiempo de uso total: 1800 hs',
                        textAlign: pw.TextAlign.left,
                      ),

                    ],
                    crossAxisAlignment: pw.CrossAxisAlignment.start)),
                pw.SizedBox(width: 20),
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        padding: const pw.EdgeInsets.only(bottom: 10),
                        child: pw.Text(
                          'Locks',
                          style: const pw.TextStyle(
                            color: baseColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Puerta 1',
                            textAlign: pw.TextAlign.left,
                          ),
                          pw.Text(
                            'Disponible',
                            textAlign: pw.TextAlign.left,
                          ),
                        ]
                      ),
                      pw.Divider(),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Puerta 2',
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.Text(
                              'Ocupada',
                              textAlign: pw.TextAlign.left,
                            ),
                          ]
                      ),
                      pw.Divider(),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Puerta 3',
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.Text(
                              'Disponible',
                              textAlign: pw.TextAlign.left,
                            ),
                          ]
                      ),
                      pw.Divider(),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Puerta 4',
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.Text(
                              'Fuera de Servicio',
                              textAlign: pw.TextAlign.left,
                            ),
                          ]
                      ),
                      pw.Divider(),

                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  // Second page with a pie chart
 /* document.addPage(
    pw.Page(
      pageFormat: pageFormat,
      theme: theme,
      build: (context) {
        const chartColors = [
          PdfColors.blue300,
          PdfColors.green300,
          PdfColors.amber300,
          PdfColors.pink300,
          PdfColors.cyan300,
          PdfColors.purple300,
          PdfColors.lime300,
        ];

        return pw.Column(
          children: [
            pw.Flexible(
              child: pw.Chart(
                title: pw.Text(
                  'Expense breakdown',
                  style: const pw.TextStyle(
                    color: baseColor,
                    fontSize: 20,
                  ),
                ),
                grid: pw.PieGrid(),
                datasets: List<pw.Dataset>.generate(dataTable.length, (index) {
                  final data = dataTable[index];
                  final color = chartColors[index % chartColors.length];
                  final value = (data[2] as num).toDouble();
                  final pct = (value / expense * 100).round();
                  return pw.PieDataSet(
                    legend: '${data[0]}\n$pct%',
                    value: value,
                    color: color,
                    legendStyle: const pw.TextStyle(fontSize: 10),
                  );
                }),
              ),
            ),
            table,
          ],
        );
      },
    ),
  );*/

 /* final file = File("trap_report.pdf");
  await file.writeAsBytes(await document.save());*/

  // Return the PDF file content
  return document.save();

 /* return PdfPreview(
    build: (format) => document.save(),
  );*/
}