//import 'dart:html';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'dart:typed_data';
//import 'package:printing/printing.dart';
import 'package:second_draft/Models/Report.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

Future<Uint8List> makePdf(Report report) async {

  final imageLogo = MemoryImage((await rootBundle.load('assets/images/logo.png')).buffer.asUint8List());
  final pdf = Document();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.Text("Horticulture Division", style: pw.TextStyle(fontSize: 30)),
                    pw.Text("Daily Maintenance Log Book", style: pw.TextStyle(fontSize: 20)),
                  ],
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                ),
                pw.SizedBox(
                  height: 150,
                  width: 150,
                  child: pw.Image(imageLogo),
                )
              ],
            ),
            pw.Container(height: 50),
            buildGeneralInfo(report.generalInfo),
            pw.Container(height: 20),
            buildEnvironmentInfo(report.environmentInfo),
            pw.Container(height: 20),
            buildManpowerInfo(report.manpowerInfo),
            pw.Container(height: 20),
            pw.Text(
              "Prepared By: ${report.name}",
              style: pw.Theme.of(context).header2,
            ),
            pw.Divider(
              height: 1,
              borderStyle: pw.BorderStyle.dashed,
            ),
          ],
        );
      },
    ),
  );

  return pdf.save();
}

pw.Widget buildGeneralInfo(GeneralInfo generalInfo) {
  return Table(
    border: TableBorder.all(color: PdfColors.black),
    children: [
      TableRow(
        children: [
          PaddedText('Date', align: TextAlign.center),
          PaddedText(generalInfo.date, align: TextAlign.center),
        ],
      ),
      TableRow(
        children: [
          PaddedText('Company', align: TextAlign.center),
          PaddedText(generalInfo.company, align: TextAlign.center),
        ],
      ),
      TableRow(
        children: [
          PaddedText('Location', align: TextAlign.center),
          PaddedText(generalInfo.location, align: TextAlign.center),
        ],
      ),
      TableRow(
        children: [
          PaddedText('Contractor', align: TextAlign.center),
          PaddedText(generalInfo.contractor, align: TextAlign.center),
        ],
      ),
      TableRow(
        children: [
          PaddedText('Supervisor', align: TextAlign.center),
          PaddedText(generalInfo.supervisor, align: TextAlign.center),
        ],
      ),
    ],
  );
}

pw.Widget buildEnvironmentInfo(EnvironmentInfo environmentInfo) {
  return Table(
    border: TableBorder.all(color: PdfColors.black),
    children: [
      TableRow(
        children: [
          PaddedText('Weather', align: TextAlign.center),
          PaddedText(environmentInfo.weather, align: TextAlign.center),
        ],
      ),
      TableRow(
        children: [
          PaddedText('Temperature', align: TextAlign.center),
          PaddedText(environmentInfo.temp, align: TextAlign.center),
        ],
      ),
      TableRow(
        children: [
          PaddedText('Wind', align: TextAlign.center),
          PaddedText(environmentInfo.wind, align: TextAlign.center),
        ],
      ),
      TableRow(
        children: [
          PaddedText('Humidity', align: TextAlign.center),
          PaddedText(environmentInfo.humidity, align: TextAlign.center),
        ],
      ),
    ],
  );
}

pw.Widget buildManpowerInfo(ManpowerInfo manpowerInfo) {
  return Table(
    border: TableBorder.all(color: PdfColors.black),
    children: [
      TableRow(
        children: [
          PaddedText('Skilled', align: TextAlign.center),
          PaddedText(manpowerInfo.skilled, align: TextAlign.center),
        ],
      ),
      TableRow(
        children: [
          PaddedText('Semi-Skilled', align: TextAlign.center),
          PaddedText(manpowerInfo.semiSkilled, align: TextAlign.center),
        ],
      ),
      TableRow(
        children: [
          PaddedText('Unskilled', align: TextAlign.center),
          PaddedText(manpowerInfo.unskilled, align: TextAlign.center),
        ],
      ),
      TableRow(
        children: [
          PaddedText('Supervisor', align: TextAlign.center),
          PaddedText(manpowerInfo.supervisors, align: TextAlign.center),
        ],
      ),
      TableRow(
        children: [
          PaddedText('Irrigation Technician', align: TextAlign.center),
          PaddedText(manpowerInfo.irrigationTech, align: TextAlign.center),
        ],
      ),
      TableRow(
        children: [
          PaddedText('Horticulturist', align: TextAlign.center),
          PaddedText(manpowerInfo.horticulturist, align: TextAlign.center),
        ],
      ),
      TableRow(
        children: [
          PaddedText('Managers', align: TextAlign.center),
          PaddedText(manpowerInfo.managers, align: TextAlign.center),
        ],
      ),
    ],
  );
}

class PaddedText extends pw.StatelessWidget {
  final String text;
  final TextAlign align;

  PaddedText(this.text, {required this.align});

  @override
  pw.Widget build(Context context) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(2),
      child: pw.Text(
        text,
        textAlign: align,
      ),
    );
  }
}