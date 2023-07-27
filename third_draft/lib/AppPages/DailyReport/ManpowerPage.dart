import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:second_draft/AppPages/DailyReport/PDFViewer.dart';
import 'package:second_draft/Models/Report.dart';


class ManpowerPage extends StatefulWidget{
  const ManpowerPage({super.key});
  @override
  State<ManpowerPage> createState() => ManpowerPageState();
}

class ManpowerPageState extends State<ManpowerPage>{

  String skilled="";
  String semiSkilled="";
  String unskilled="";
  String supervisors="";
  String irrigationTech="";
  String horticulturist="";
  String managers="";
  String response="";

  @override
  Widget build(BuildContext context) {
    ReportProvider reportProvider = context.watch<ReportProvider>();
    Report report = reportProvider.report;
    return Scaffold(
      appBar: AppBar(title: const Text('Manpower'),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 30,),
            const Text('Enter number of skilled workers', style: TextStyle(fontSize: 20, color: Colors.black),),
            SizedBox( width: 150, child: TextField(
              maxLength: 10,
              cursorHeight: 30,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              onChanged: (String newValue){
                setState(() {
                  skilled = newValue;
                });
              },
            ),
            ),
            Container(height: 20,),
            const Text('Enter number of Semi-Skilled workers', style: TextStyle(fontSize: 20, color: Colors.black),),
            SizedBox( width: 150, child: TextField(
              maxLength: 10,
              cursorHeight: 30,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              onChanged: (String newValue){
                setState(() {
                  semiSkilled = newValue;
                });
              },
            ),
            ),
            Container(height: 20,),
            const Text('Enter number of Unskilled workers', style: TextStyle(fontSize: 20, color: Colors.black),),
            SizedBox( width: 150, child: TextField(
              maxLength: 10,
              cursorHeight: 30,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              onChanged: (String newValue){
                setState(() {
                  unskilled = newValue;
                });
              },
            ),
            ),
            Container(height: 20,),
            const Text('Enter number of Supervisors', style: TextStyle(fontSize: 20, color: Colors.black),),
            SizedBox( width: 150, child: TextField(
              maxLength: 10,
              cursorHeight: 30,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              onChanged: (String newValue){
                setState(() {
                  supervisors = newValue;
                });
              },
            ),
            ),
            Container(height: 20,),
            const Text('Enter number of Irrigation Technicians', style: TextStyle(fontSize: 20, color: Colors.black),),
            SizedBox( width: 150, child: TextField(
              maxLength: 10,
              cursorHeight: 30,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              onChanged: (String newValue){
                setState(() {
                  irrigationTech = newValue;
                });
              },
            ),
            ),
            Container(height: 20,),
            const Text('Enter number of Horticulturist', style: TextStyle(fontSize: 20, color: Colors.black),),
            SizedBox( width: 150, child: TextField(
              maxLength: 10,
              cursorHeight: 30,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              onChanged: (String newValue){
                setState(() {
                  horticulturist = newValue;
                });
              },
            ),
            ),
            Container(height: 20,),
            const Text('Enter number of AM/PM/GM/MD', style: TextStyle(fontSize: 20, color: Colors.black),),
            SizedBox( width: 150, child: TextField(
              maxLength: 10,
              cursorHeight: 30,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              onChanged: (String newValue){
                setState(() {
                  managers = newValue;
                });
              },
            ),
            ),
            Container(height: 20,),
            ElevatedButton(
              onPressed: (){
                if(skilled.isEmpty || semiSkilled.isEmpty || unskilled.isEmpty || supervisors.isEmpty || irrigationTech.isEmpty || horticulturist.isEmpty || managers.isEmpty){
                  setState(() {
                    response="Please enter valid inputs";
                  });
                }
                else{
                  report.manpowerInfo=ManpowerInfo(skilled, semiSkilled, unskilled, supervisors, irrigationTech, horticulturist, managers);
                  reportProvider.setReport(report);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>PdfPreviewPage(report: report))
                  );
                }
              },
              child: const Text('Next', style: TextStyle(fontSize: 20),),
            ),
            Text(response, style: const TextStyle(color: Colors.red),)
          ],
        ),
      )
    );
  }

}