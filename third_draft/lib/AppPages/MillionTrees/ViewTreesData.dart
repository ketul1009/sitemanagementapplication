import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:second_draft/AppPages/MillionTrees/TreesReportSubmissionPage.dart';
import '../../Models/TreePlantationReport.dart';
import '../LoginPage.dart';

class ViewTreesDataPage extends StatefulWidget{
  ViewTreesDataPage({super.key});

  @override
  State<ViewTreesDataPage> createState() => ViewTreesDataPageState();
}

class ViewTreesDataPageState extends State<ViewTreesDataPage>{
  bool isLoading = false;
  List<TreePlantationReport> _records = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  DataTableSource _data = RecordData([]);

  Future<void> fetchDocuments() async {
    setState(() {
      isLoading=true;
    });
    final url = Uri.parse("https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/plantationreport");
    try {
      List<TreePlantationReport> documents = [];
      final response = await http.post(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'preparedBy':user.userId})
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for (var value in data['Items']){
          var temp = value;
          debugPrint(temp.toString());
          documents.add(
              TreePlantationReport(
                temp['company'],
                temp['time'],
                temp['month'],
                temp['year'],
                temp['trees'],
                temp['comments']
              )
          );
        }

        setState(() {
          _records=documents;
        });
      }
      else {
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      isLoading=false;
      _data=RecordData(_records);
    });
  }

  @override
  void initState() {
    super.initState();
    // Set the system overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make the status bar transparent
        statusBarIconBrightness: Brightness.dark, // Dark status bar icons
      ),
    );
    // Enable fullscreen mode
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );
    fetchDocuments();
  }

  Widget build(BuildContext context){
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
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu, size: 30, color: Colors.black),
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
                      child: Text("Refresh"),
                    ),
                  ];
                },
                onSelected:(value) {
                  if (value == 0) {
                    fetchDocuments();
                  }
                }
            ),
          ],
          elevation: 2,
          backgroundColor: Colors.white,
        ),
        drawer: Drawer(
          // Add your menu items inside the Drawer
          child: Column(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                color: Colors.blue,
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(20),
                child: const Text("Welcome", style: TextStyle(fontSize: 20),),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(height: 10,),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TreeReportSubmissionPage())
                      );
                    },
                    style: const ButtonStyle(),
                    child: SizedBox(
                        width: 150,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('New Record', style: TextStyle(fontSize: 16 , color: Colors.black),),
                              Icon(Icons.add, color: Colors.black,),
                            ])
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if(isLoading)
                        const CircularProgressIndicator()
                    ],
                  ),
                  PaginatedDataTable(
                    columns: const [
                      DataColumn(
                        label: Text('Company'),
                      ),
                      DataColumn(
                        label: Text('Date'),
                      ),
                      DataColumn(
                        label: Text('Year'),
                      ),
                      DataColumn(
                        label: Text('Month'),
                      ),
                      DataColumn(
                        label: Text('Trees'),
                      ),
                      DataColumn(
                        label: Text('Comments'),
                      ),
                    ],
                    source: _data,
                  )
                ]
            )
        ),
      ),
    );
  }
}

class RecordData extends DataTableSource{

  List<Map<String, dynamic>> _data = List.generate(
      1,
          (index) => {
        "Date": "Date",
        "Company": "Company",
        "Year": "Year",
        "Month": "Month",
        "Trees":"Trees",
        "Comments": "Comments",
      });

  RecordData(List<TreePlantationReport> temp){
    _data = List.generate(
        temp.length,
            (index) => {
              "Date" : temp[index].time,
              "Company" :temp[index].company,
              "Year" : temp[index].year,
              "Month": temp[index].month,
              "Trees": temp[index].treeNumber,
              "Comments": temp[index].comments
        });
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]["Date"])),
      DataCell(Text(_data[index]["Company"])),
      DataCell(Text(_data[index]["Year"])),
      DataCell(Text(_data[index]["Month"])),
      DataCell(Text(_data[index]["Trees"])),
      DataCell(Text(_data[index]["Comments"])),
    ]);
  }
}