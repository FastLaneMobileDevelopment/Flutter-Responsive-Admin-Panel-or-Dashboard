import 'package:flutter/material.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/services/export_pdf.dart';

import '../../../constants.dart';

class PDFReportPage extends StatefulWidget {

  final List<YupcityRegister> allRegistries;
  final YupcityTrapPoi currentTrap;

  PDFReportPage(this.allRegistries,this.currentTrap);
  @override
  State<PDFReportPage> createState() => _PDFReportPageState();
}

class _PDFReportPageState extends State<PDFReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:  Text("Centro La Maquinista"),
        backgroundColor: secondaryColor
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PDFReport(widget.currentTrap),
              ]
      ),
        ),
    ));
  }



}
