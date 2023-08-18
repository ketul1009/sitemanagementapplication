import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:second_draft/AppPages/MillionTrees/TreeMission.dart';
import 'package:second_draft/AppPages/MillionTrees/TreesReportSubmissionPage.dart';
import 'package:second_draft/Common/CustomDrawer.dart';
import '../../Common/ExcelMaker.dart';
import '../../Models/TreePlantationReport.dart';
import '../LoginPage.dart';
import 'package:second_draft/main.dart';

class ViewTreesDataPage extends StatefulWidget{
  ViewTreesDataPage({super.key});

  @override
  State<ViewTreesDataPage> createState() => ViewTreesDataPageState();
}

class ViewTreesDataPageState extends State<ViewTreesDataPage>{
  //remove all the comments here
  bool isLoading = false;
  List<TreePlantationReport> _records = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  DataTableSource _data = RecordData([]);
  int serialNo = 1;

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
          documents.add(
              TreePlantationReport(
                temp["preparedBy"],
                temp["reportId"],
                temp["time"],
                temp["business"],
                temp["subBusiness"],
                temp["location"],
                temp["month"],
                temp["year"],
                temp["treeNumber"],
                temp["comments"]
              )
          );
        }
        documents.sort((a, b) {
          return Comparable.compare(b.time, a.time);
        });
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

  Future<void> fetchDocumentsAdmin() async {
    setState(() {
      isLoading=true;
    });
    final url = Uri.parse("https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/plantationreport/admin");
    try {
      List<TreePlantationReport> documents = [];
      final response = await http.post(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'preparedBy':user.userId})
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint(data.toString());
        for (var value in data['Items']){
          var temp = value;
          documents.add(
              TreePlantationReport(
                  temp["preparedBy"],
                  temp["reportId"],
                  temp["time"],
                  temp["business"],
                  temp["subBusiness"],
                  temp["location"],
                  temp["month"],
                  temp["year"],
                  temp["treeNumber"],
                  temp["comments"]
              )
          );
        }
        documents.sort((a, b) {
          return Comparable.compare(b.time, a.time);
        });
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

  List<List<dynamic>> _createList(List<TreePlantationReport> input) {
    final List<List<dynamic>> data = [
      [
        'Business',
        'Sub-Business',
        'Location',
        'Month',
        'Year'
        'Trees',
        'Comments'
      ]
    ];

    for(var temp in input){
      List<String> row = [
        temp.business,
        temp.subBusiness,
        temp.location,
        temp.month,
        temp.year,
        temp.treeNumber,
        temp.comments
      ];
      data.add(row);
    }

    return data;
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

    if(user.role=="admin"){
      fetchDocumentsAdmin();
    }
    else{
      fetchDocuments();
    }
  }

  @override
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
                      child: Text("Refresh"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Export to Excel"),
                    ),
                  ];
                },
                onSelected:(value) {
                  if (value == 0) {
                    if(user.role=="admin"){
                      fetchDocumentsAdmin();
                    }
                    else{
                      fetchDocuments();
                    }
                  }
                  else if(value == 1){
                    exportExcel(context, _createList(_records));
                  }
                }
            ),
          ],
          elevation: 2,
          backgroundColor: Colors.white,
        ),
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(height: 10,),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TreeMission())
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
                        label: Text('Sr. No', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Date', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Business', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Sub-Business', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Location', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Year', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Month', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Trees', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Comments', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
  int serialNo=1;

  List<Map<String, dynamic>> _data = List.generate(
      1,
          (index) => {
        "Sr. No": "Sr. No",
        "Date": "Date",
        "Business": "Business",
        "Sub-Business": "Sub-Business",
        "Location": "Location",
        "Month": "Month",
        "Year": "Year",
        "Trees":"Trees",
        "Comments": "Comments",
      });

  RecordData(List<TreePlantationReport> temp){
    _data = List.generate(
        temp.length,
            (index) => {
              "Sr. No": (serialNo++).toString(),
              "Date": temp[index].time.substring(0, 11),
              "Business": temp[index].business,
              "Sub-Business": temp[index].subBusiness,
              "Location": temp[index].location,
              "Month": temp[index].month,
              "Year": temp[index].year,
              "Trees": temp[index].treeNumber,
              "Comments": temp[index].comments,
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
      DataCell(Text(_data[index]["Sr. No"])),
      DataCell(Text(_data[index]["Date"])),
      DataCell(Text(_data[index]["Business"])),
      DataCell(Text(_data[index]["Sub-Business"])),
      DataCell(Text(_data[index]["Location"])),
      DataCell(Text(_data[index]["Month"])),
      DataCell(Text(_data[index]["Year"])),
      DataCell(Text(_data[index]["Trees"])),
      DataCell(Text(_data[index]["Comments"])),
    ]);
  }
}
