import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart';
import '../../Common/PdfMaker.dart';
import 'ViewReportPage.dart';

class DetailedReportPage extends StatefulWidget{
  const DetailedReportPage({super.key});
  @override
  State<DetailedReportPage> createState() => DetailedReportPageState();
}

class DetailedReportPageState extends State<DetailedReportPage>{

  bool error=false;
  void _deleteReport() async {
    final url = Uri.parse(
        "https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/object/${selectedReport.preparedBy}/${selectedReport.reportId}");
    var response = await delete(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
    );
    debugPrint(response.statusCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.white, size: 30,),
              itemBuilder: (context){
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Delete"),
                  ),
                ];
              },
              onSelected:(value) {
                if (value == 0) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text("Are you sure?"),
                        actions: [
                          TextButton(
                              onPressed: (){
                                Navigator.of(context).pop(false);
                              },
                              child: Text("No")
                          ),
                          TextButton(
                              onPressed: (){
                                _deleteReport();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=> const ViewReportPage())
                                );
                              },
                              child: const Text("Yes")
                          ),
                        ],
                      )
                  );
                }
              }
          ),
        ],
      ),
      body: PdfPreview(
        build: (context) => makePdf(selectedReport),
      ),
    );
  }

}