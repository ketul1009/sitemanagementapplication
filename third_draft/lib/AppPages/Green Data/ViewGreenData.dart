import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:second_draft/AppPages/Green%20Data/DetailedGreenData.dart';
import 'package:second_draft/AppPages/HomePage.dart';
import 'package:second_draft/Common/CustomDrawer.dart';
import 'package:second_draft/Common/TreeSpeciesDialog.dart';
import 'package:second_draft/Models/GreenDataRecord.dart';
import 'package:http/http.dart' as http;
import '../../Common/ExcelMaker.dart';
import '../LoginPage.dart';
import 'GreenData.dart';
import 'package:second_draft/main.dart';

GreenDataRecord selectedRecord = GreenDataRecord('', '', '', '', '', '', '', '', '', []);

class ViewGreenDataPage extends StatefulWidget{
  const ViewGreenDataPage({super.key});

  @override
  State<ViewGreenDataPage> createState() => ViewGreenDataPageState();

}

class ViewGreenDataPageState extends State<ViewGreenDataPage>{

  bool isLoading = false;
  List<GreenDataRecord> _records = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  DataTableSource _data = RecordData([]);
  String serverResponse = "";
  int serialNo = 1;

  Future<void> fetchDocuments() async {
    setState(() {
      isLoading=true;
    });
    final url = Uri.parse("https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/greendata");
    try {
      List<GreenDataRecord> documents = [];
      final response = await http.post(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'userId':user.userId})
      );
      //debugPrint(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for(var item in data['Items']){
          List<SpeciesData> temp = [];
          for(var value in item['data']){
            temp.add(
                SpeciesData(value['greenZone'], value['type'], value['species'], value['quantity'], value['area'], value['date'])
            );
          }
          documents.add(
            GreenDataRecord(item['userId'], item['recordId'], item['time'].substring(0,11), item['business'], item['subBusiness'], item['location'], 'subLocation', 'site', 'greenZone', temp)
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

  Future<void> fetchDocumentsAdmin() async {
    setState(() {
      isLoading=true;
    });
    final url = Uri.parse("https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/greendata/admin");
    try {
      List<GreenDataRecord> documents = [];
      final response = await http.post(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'userId':user.userId})
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for(var item in data['Items']){
          List<SpeciesData> temp = [];
          for(var value in item['data']){
            temp.add(
                SpeciesData(value['greenZone'], value['type'], value['species'], value['quantity'], value['area'], value['date'])
            );
          }
          documents.add(
              GreenDataRecord(item['userId'], item['recordId'], item['time'].substring(0,11), item['business'], item['subBusiness'], item['location'], 'subLocation', 'site', 'greenZone', temp)
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

  List<List<dynamic>> _createList(List<GreenDataRecord> input) {
    final List<List<dynamic>> data = [
      [
        'Business',
        'Sub-Business',
        'Location',
        'Type',
        'Species',
        'Quantity',
        'Area',
        'Date',
      ]
    ];
    for(var temp in input){
      for(var speciesData in temp.data){
        List<String> row = [];
        row.add(temp.business);
        row.add(temp.subBusiness);
        row.add(temp.location);
        row.add(speciesData.type);
        row.add(speciesData.species);
        row.add(speciesData.quantity);
        row.add(speciesData.area);
        row.add(speciesData.date);
        data.add(row);
      }
    }
    
    //debugPrint(data.toString());
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
          Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const HomePage())
          );
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
                    exportGreenData(_createList(_records));
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
                        MaterialPageRoute(builder: (context) => const GreenData())
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
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        showCheckboxColumn: false,
                        columns: const [
                          DataColumn(label: Text("Sr. No", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text("Business", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text("Sub-Business", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text("Location", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text("Date", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                        ],
                        rows: _records.map(
                                (reportRow) => DataRow(
                                onSelectChanged: (selected){
                                  selectedRecord=reportRow;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context)=>const DetailedGreenData())
                                  );
                                },
                                cells: [
                                  DataCell(
                                    Text((serialNo++).toString()),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    Text(reportRow.business),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    Text(reportRow.subBusiness),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    Text(reportRow.location),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                  DataCell(
                                    Text(reportRow.time.substring(0,11)),
                                    showEditIcon: false,
                                    placeholder: false,
                                  ),
                                ]
                            )
                        ).toList(),
                      ),
                    ),
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
        "Business": "Business",
        "Sub-Business": "Sub-Business",
        "Location": "Location",
        "Date": "Date",
      });

  RecordData(List<GreenDataRecord> temp){
    _data = List.generate(
        temp.length,
            (index) => {
            "business": temp[index].business,
            "subBusiness": temp[index].subBusiness,
            "location": temp[index].location,
            "date": temp[index].time,
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
      DataCell(Text(_data[index]['business'])),
      DataCell(Text(_data[index]['subBusiness'])),
      DataCell(Text(_data[index]['location'])),
      DataCell(Text(_data[index]['date'])),
    ]);
  }
}