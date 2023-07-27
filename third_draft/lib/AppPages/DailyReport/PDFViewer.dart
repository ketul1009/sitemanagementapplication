import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:printing/printing.dart';
import 'package:random_string/random_string.dart';
import 'package:second_draft/AppPages/DailyReport/ViewReportPage.dart';
import 'package:second_draft/AppPages/HomePage.dart';
import '../../Common/PdfMaker.dart';
import '../../Models/Report.dart';
import 'package:http/http.dart' as http;

class PdfPreviewPage extends StatefulWidget {
  final Report report;
  const PdfPreviewPage({Key? key, required this.report}) : super(key: key);

  @override
  State<PdfPreviewPage> createState() => PdfPreviewPageState(report);

}

class PdfPreviewPageState extends State<PdfPreviewPage> {
  Report report;
  String response="";
  bool error=false;

  PdfPreviewPageState(this.report);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
      ),
      persistentFooterButtons: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (){
                      _verifyAndSubmit();
                      if(!error){
                        showDialog(
                            context: context,
                            builder: (context)=> AlertDialog(
                              title: const Text("Submitted Successfully"),
                              content: const Text("Your report is submitted"),
                              actions: [
                                TextButton(
                                    onPressed: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context)=> const ViewReportPage())
                                      );
                                    },
                                    child: const Text("View all reports")),
                                TextButton(
                                    onPressed: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context)=> HomePage())
                                      );
                                    },
                                    child: const Text("Go to home")),
                              ],
                            )
                        );
                      }
                      setState(() {
                        error=false;
                      });
                    },
                    child: const Text("Submit"))
              ],
            ),
            if(error)
              Text(response, style: TextStyle(color: Colors.red),)
          ],
        )
      ],
      body: PdfPreview(
        canChangePageFormat: false,
        canDebug: false,
        canChangeOrientation: false,
        build: (context) => makePdf(report),
      ),
    );
  }

  void _verifyAndSubmit() async {
    var isConnected = await InternetConnectionChecker().hasConnection;
    if (!isConnected) {
      setState(() {
        response="Please check your Internet Connection";
      });
    }
    else{
      _submitReport();
    }

  }

  void _submitReport() async {
    String recordId = randomAlphaNumeric(6);
    final url = Uri.parse("https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/submit/dailyreport");
    try{
      var res = await http.post(url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({
          'preparedBy': report.preparedBy,
          'name': report.name,
          'reportId': report.reportId,
          'date': report.generalInfo.date,
          'company': report.generalInfo.company,
          'location': report.generalInfo.location,
          'contractor': report.generalInfo.contractor,
          'weather': report.environmentInfo.weather,
          'temp': report.environmentInfo.temp,
          'wind': report.environmentInfo.wind,
          'humidity': report.environmentInfo.humidity,
          'skilled': report.manpowerInfo.skilled,
          'semiSkilled': report.manpowerInfo.semiSkilled,
          'unskilled': report.manpowerInfo.unskilled,
          'supervisors': report.manpowerInfo.supervisors,
          'irrigationTech': report.manpowerInfo.irrigationTech,
          'horticulturist': report.manpowerInfo.horticulturist,
          'managers': report.manpowerInfo.managers,
          'supervisor': report.generalInfo.supervisor,
          'signedBy': report.signedBy,
        }),
      );
      debugPrint(res.body);
      if(res.statusCode!=200){
        setState(() {
          error=true;
          response="Some error occurred";
        });
      }
    }
    catch (err){
      error=true;
      response="Some error occurred";
    }
  }
}