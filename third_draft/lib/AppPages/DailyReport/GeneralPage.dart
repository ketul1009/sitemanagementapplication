import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:second_draft/AppPages/DailyReport/EnvironmentPage.dart';
import 'package:second_draft/Models/WaterUsageRecord.dart';
import 'package:second_draft/Models/Report.dart';
import '../LoginPage.dart';

class GeneralPage extends StatefulWidget{
  GeneralPage({super.key});

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage>{

  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.fromDateTime(DateTime.now());
  List<String> airports = [
    'Airport',
    'BOM',
    'IXE',
    'JAI',
    'LKO',
    'AMD',
    'TRV',
    'GAU',
    'NBOM',
  ];
  List<String> locations = [
    'Location',
    'Indoor',
    'Outdoor',
  ];
  String selectedCompany = 'Airport';
  String selectedLocation = 'Location';
  String contractor="";
  String supervisor="";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
      drawer: Drawer(
        // Add your menu items inside the Drawer
        child: ListView(
          children: [
            Container(
                decoration: const BoxDecoration(color: Colors.blue),
                height: 100,
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.topRight,
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.settings)
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Text("Welcome "+user.name+", "+user.email)
                    ),
                  ],
                )
            ),
            ListTile(
              title: Text('Feature 1'),
              onTap: () {
                // Handle item 1 tap
              },
            ),
            ListTile(
              title: Text('Feature 2'),
              onTap: () {
                // Handle item 2 tap
              },
            ),
            // Add more items as needed
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 40,),
            TextButton(
              onPressed: () async {
                _selectDate(context);
                _selectTime(context);
              },
              child: Text("${date.toString().split(' ')[0]} ${time.hourOfPeriod}:${time.minute} ${time.period.name.toUpperCase()}",
                style: TextStyle(color: Colors.black,
                    fontSize: 20
                ),
              ),
            ),
            Container(height: 10,),
            Text('Select Airport', style: TextStyle(fontSize: 20, color: Colors.black),),
            Container(height: 10,),
            DropdownButton(
              // Initial Value
              value: selectedCompany,
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),
              // Array list of items
              items: airports.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  selectedCompany = newValue!;
                });
              },
            ),
            Container(height: 30,),
            Text('Select Location', style: TextStyle(fontSize: 20, color: Colors.black),),
            Container(height: 10,),
            DropdownButton(
              // Initial Value
              value: selectedLocation,
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),
              // Array list of items
              items: locations.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  selectedLocation = newValue!;
                });
              },
            ),
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
                if(selectedCompany=="Airport" || selectedLocation=="Location" || contractor.isEmpty || supervisor.isEmpty){
                  setState(() {
                    response="Please enter valid inputs";
                  });
                }
                else{
                  String formattedDateTime = "${date.toString().split(' ')[0]} ${time.hourOfPeriod}:${time.minute} ${time.period.name.toUpperCase()}";
                  report.generalInfo=GeneralInfo(formattedDateTime, selectedCompany, selectedLocation, contractor, supervisor);
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: time,
    );

    if (pickedTime != null && pickedTime != time) {
      setState(() {
        time = pickedTime;
      });
    }
  }
}
