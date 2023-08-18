import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;
import 'package:second_draft/main.dart';
import '../../Common/CustomDrawer.dart';
import '../../Models/TreePlantationReport.dart';
import '../LoginPage.dart';

class TreeReportSubmissionPage extends StatefulWidget{
  TreeReportSubmissionPage({super.key});

  @override
  State<TreeReportSubmissionPage> createState() => TreeReportSubmissionPageState();
}

class TreeReportSubmissionPageState extends State<TreeReportSubmissionPage>{

  List<String> months = [
    'Month',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<String> years = [
    'Year',
    '2023',
    '2022',
    '2021',
    '2020',
    '2019'
  ];
  String selectedMonth="Month";
  String selectedYear="Year";
  String number="";
  String comments="";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  bool error=false;

  @override
  Widget build(BuildContext context) {
    TreeReportProvider treeReportProvider = context.watch<TreeReportProvider>();
    TreePlantationReport treePlantationReport = treeReportProvider.treePlantationReport;
    return WillPopScope(
      onWillPop: () async {
        if(!drawerOpen) {
          Navigator.pop(context);
          return false;
        }
        else{
          setState(() {
            drawerOpen=false;
          });
          _scaffoldKey.currentState?.closeDrawer();
          return false;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
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
          elevation: 2,
          backgroundColor: Colors.white,
        ),
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(height: 40,),
                const Text('Select Year', style: TextStyle(fontSize: 20, color: Colors.black),),
                Container(height: 10,),
                DropdownButton(
                  // Initial Value
                  value: selectedYear,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: years.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedYear = newValue!;
                    });
                  },
                ),
                const Text('Select Month', style: TextStyle(fontSize: 20, color: Colors.black),),
                Container(height: 10,),
                DropdownButton(
                  // Initial Value
                  value: selectedMonth,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: months.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMonth = newValue!;
                    });
                  },
                ),
                Container(height: 30,),
                const Text('Enter number of Trees', style: TextStyle(fontSize: 20, color: Colors.black),),
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
                      number = newValue;
                    });
                  },
                ),
                ),
                Container(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Border color
                      width: 1.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(10.0), // Border radius
                  ),
                  width: 300,
                  height: 100,
                  child: TextField(
                    onChanged: (newValue){
                      setState(() {
                        number=newValue;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Comments',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      border: InputBorder.none, // Hide the default border of TextField
                    ),
                  ),
                ),
                Container(height: 20,),
                ElevatedButton(
                  onPressed: (){
                    if(selectedMonth=="Month" || selectedYear=="Year" || number.isEmpty){
                      showDialog(context: context, builder: (BuildContext context){
                        return AlertDialog(
                          title: const Text('Invalid input'),
                          content: const Text('Please enter valid Input'),
                          actions: <Widget>[
                            IconButton(onPressed: (){
                              Navigator.of(context).pop(false);
                            }, icon: const Icon(Icons.check))
                          ],
                        );
                      });
                    }
                    else{
                      String formattedDateTime = DateTime.now().toString();
                      _submitData(treePlantationReport.business,
                          treePlantationReport.subBusiness,
                          treePlantationReport.location,
                          selectedMonth, selectedYear, number, comments);
                      if(!error){
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            title: const Text('Successful'),
                            content: const Text('Your submission is recorded'),
                            actions: <Widget>[
                              IconButton(onPressed: (){
                                Navigator.of(context).pop(false);
                                Navigator.of(context).pop(false);
                              }, icon: const Icon(Icons.check))
                            ],
                          );
                        });
                      }
                      else{
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            title: const Text('Submission Failed'),
                            content: const Text('Some internal error occurred'),
                            actions: <Widget>[
                              IconButton(onPressed: (){
                                Navigator.of(context).pop(false);
                              }, icon: const Icon(Icons.check))
                            ],
                          );
                        });
                      }
                    }
                  },
                  child: const Text('Submit', style: TextStyle(fontSize: 20),),
                ),
              ],
            )
        ),
      ),
    );
  }

  _submitData(String business, String subBusiness, String location, String month, String year, String treeNumber, String comments) async {
    setState(() {
      error=false;
    });
    String recordId = randomAlphaNumeric(6);
    final url = Uri.parse("https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/submit/plantationreport");
    try{
      var res = await http.post(url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode({
          'reportId':recordId ,
          'preparedBy': user.userId,
          'time':DateTime.now().toString(),
          'business': business,
          'subBusiness': subBusiness,
          'location': location,
          'month': month,
          'year': year,
          'treeNumber': treeNumber,
          'comments': comments
          }),
      );
      debugPrint(res.body);
      if(res.statusCode!=200){
        setState(() {
          error=true;
        });
      }
    }
    catch(err){
      setState(() {
        error=true;
      });
    }
  }

}