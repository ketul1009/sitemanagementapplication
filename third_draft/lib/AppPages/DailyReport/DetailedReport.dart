import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart';
import '../../Common/CustomDrawer.dart';
import '../../Common/PdfMaker.dart';
import '../HomePage.dart';
import 'ViewReportPage.dart';
import 'package:second_draft/main.dart';

class DetailedReportPage extends StatefulWidget{
  const DetailedReportPage({super.key});
  @override
  State<DetailedReportPage> createState() => DetailedReportPageState();
}

class DetailedReportPageState extends State<DetailedReportPage>{

  bool error=false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  String response="";

  void _deleteReport() async {
    final url = Uri.parse(
        "https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/dailyreport/object/${user.userId}/${selectedReport.reportId}");
    var response = await delete(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
    );
  }

  void _signReport() async {
    final url = Uri.parse(
        "https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/sign");
    try{
      var res = await put(
        url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode({
          'preparedBy': selectedReport.preparedBy,
          'name': selectedReport.name,
          'reportId': selectedReport.reportId,
          'date': selectedReport.generalInfo.date,
          'business': selectedReport.generalInfo.business,
          'subBusiness': selectedReport.generalInfo.subBusiness,
          'location': selectedReport.generalInfo.location,
          'contractor': selectedReport.generalInfo.contractor,
          'weather': selectedReport.environmentInfo.weather,
          'temp': selectedReport.environmentInfo.temp,
          'wind': selectedReport.environmentInfo.wind,
          'humidity': selectedReport.environmentInfo.humidity,
          'skilled': selectedReport.manpowerInfo.skilled,
          'semiSkilled': selectedReport.manpowerInfo.semiSkilled,
          'unskilled': selectedReport.manpowerInfo.unskilled,
          'supervisors': selectedReport.manpowerInfo.supervisors,
          'irrigationTech': selectedReport.manpowerInfo.irrigationTech,
          'horticulturist': selectedReport.manpowerInfo.horticulturist,
          'managers': selectedReport.manpowerInfo.managers,
          'supervisor': selectedReport.generalInfo.supervisor,
          'signedBy': user.name,
        })
      );
      debugPrint(res.body.toString());
      if(res.statusCode!=200){
        setState(() {
          error=true;
          response="Some error occurred";
        });
      }
    }
    catch(err){
      setState(() {
        error=true;
        response="Some error occurred";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(selectedReport.signedBy);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 50, color: Colors.black),
          onPressed: () {
            setState(() {
              drawerOpen=true;
            });
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.black, size: 30,),
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
                      builder: (context)=> AlertDialog(
                        title: const Text("Are you sure?"),
                        content: const Text("This action is irreversible"),
                        actions: [
                          TextButton(
                              onPressed: (){
                                _deleteReport();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=> const ViewReportPage())
                                );
                              },
                              child: const Text("Yes")),
                          TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: const Text("No")),
                        ],
                      )
                  );
                }
              }
          ),
        ],
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      drawer: const CustomDrawer(),
      persistentFooterButtons: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (){
                      _signReport();
                      if(!error){
                        showDialog(
                            context: context,
                            builder: (context)=> AlertDialog(
                              title: const Text("Signed Successfully"),
                              content: const Text("Your report is signed"),
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
                                          MaterialPageRoute(builder: (context)=> const HomePage())
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
                    child: const Text("Sign Report"))
              ],
            ),
            if(error)
              Text(response, style: const TextStyle(color: Colors.red),)
          ],
        )
      ],
      body: PdfPreview(
        build: (context) => makePdf(selectedReport),
      ),
    );
  }

}