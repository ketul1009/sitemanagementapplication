import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:second_draft/AppPages/DailyReport/EnvironmentPage.dart';
import 'package:second_draft/Common/CustomDrawer.dart';
import 'package:second_draft/Common/DateAndTimePicker.dart';
import 'package:second_draft/Models/WaterUsageRecord.dart';
import 'package:second_draft/Models/DailyReport.dart';
import '../LoginPage.dart';
import 'package:second_draft/main.dart';

class GeneralPage extends StatefulWidget{
  const GeneralPage({super.key});

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage>{

  String date="";
  String contractor="";
  String supervisor="";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  String response="";

  @override
  Widget build(BuildContext context){
    ReportProvider reportProvider = context.watch<ReportProvider>();
    Report report = reportProvider.report;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, size: 50, color: Colors.black),
          onPressed: () {
            setState(() {
              drawerOpen=true;
            });
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 40,),
            DateAndTimePicker(
                title: "Select Date",
                onDataSubmission: (String data){
                setState(() {
                  date=data;
                });
            }),
            Container(height: 30,),
            Text('Contractor', style: TextStyle(fontSize: 20, color: Colors.black),),
            Container( width: 150, child: TextField(
              maxLength: 10,
              cursorHeight: 30,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              onChanged: (String newValue){
                setState(() {
                  contractor = newValue;
                });
              },
            ),
            ),
            Container(height: 20,),
            Text('Supervisor', style: TextStyle(fontSize: 20, color: Colors.black),),
            Container( width: 150, child: TextField(
              maxLength: 10,
              cursorHeight: 30,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              onChanged: (String newValue){
                setState(() {
                  supervisor = newValue;
                });
              },
            ),
            ),
            Container(height: 20,),
            ElevatedButton(
              onPressed: (){
                if(contractor.isEmpty || supervisor.isEmpty || date.isEmpty){
                  setState(() {
                    response="Please enter valid inputs";
                  });
                }
                else{
                  report.generalInfo.date=date;
                  report.generalInfo.contractor=contractor;
                  report.generalInfo.supervisor=supervisor;
                  report.preparedBy=user.userId;
                  report.name=user.name;
                  report.reportId=randomAlphaNumeric(6);
                  reportProvider.setReport(report);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>const EnvironmentPage())
                  );
                }
              },
              child: Text('Next', style: TextStyle(fontSize: 20),),
            ),
            Text(response, style: const TextStyle(color: Colors.red),)
          ],
        ),
      ),
    );
  }
}
