import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:multiselect/multiselect.dart';
import 'package:second_draft/AppPages/Water%20Usage/WaterUsage.dart';
import 'package:second_draft/Common/CustomDrawer.dart';
import '../../Common/ExcelMaker.dart';
import '../../Models/WaterUsageRecord.dart';
import 'package:second_draft/main.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {

  bool isLoading = false;
  List<WaterUsageRecord> _documents = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  DataTableSource _data = RecordData([]);
  bool _sortAscending = true;
  Set<String> business = {'All'};
  Set<String> subBusiness = {'All'};
  Set<String> location = {'All'};
  List<String> selectedBusiness = [];
  List<String> selectedSubBusiness = [];
  List<String> selectedLocation = [];

  Future<void> _fetchDocuments() async {
    setState(() {
      isLoading=true;
    });
    final url = Uri.parse("https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/records");
    try {
      List<WaterUsageRecord> documents = [];
      final response = await http.post(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'userId':user.userId})
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for (var value in data['Items']){
          var temp = value;
          business.add(temp['business']);
          subBusiness.add(temp['subBusiness']);
          location.add(temp['location']);
          documents.add(
              WaterUsageRecord(
                  temp['userId'],
                  temp['recordId'],
                  temp['time'].substring(0, 11),
                  temp['business'],
                  temp['subBusiness'],
                  temp['location'],
                  temp['date'],
                  temp['area'],
                  temp['weather'],
                  temp['waterUsage']
              ),
          );
        }
        documents.sort((a, b) {
          return Comparable.compare(b.time, a.time);
        });
        setState(() {
          _documents=documents;
        });
      }
      else {
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      isLoading=false;
      _data=RecordData(_documents);
    });
  }

  Future<void> _fetchDocumentsAdmin() async {
    setState(() {
      isLoading=true;
    });
    final url = Uri.parse("https://gqori3shog.execute-api.ap-south-1.amazonaws.com/dev/secondDraftApi/records/admin");
    try {
      List<WaterUsageRecord> documents = [];
      final response = await http.post(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'userId':user.userId})
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for (var value in data['Items']){
          var temp = value;
          business.add(temp['business']);
          subBusiness.add(temp['subBusiness']);
          location.add(temp['location']);
          documents.add(
            WaterUsageRecord(
                temp['userId'],
                temp['recordId'],
                temp['time'].substring(0, 11),
                temp['business'],
                temp['subBusiness'],
                temp['location'],
                temp['date'],
                temp['area'],
                temp['weather'],
                temp['waterUsage']
            ),
          );
        }
        documents.sort((a, b) {
          return Comparable.compare(b.time, a.time);
        });
        setState(() {
          _documents=documents;
        });
      }
      else {
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      isLoading=false;
      _data=RecordData(_documents);
    });
  }

  /*void _sortData(int columnIndex, bool ascending) {
    setState(() {
      _sortAscending = ascending;

      _documents.sort((a, b) {
        final aValue = _getValue(a, columnIndex);
        final bValue = _getValue(b, columnIndex);
        final comparison = ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
        return comparison;
      });
      setState(() {
        _data=RecordData(_documents);
      });
    });
  }
  */
  List<WaterUsageRecord> filterData(List<String> selectedBusiness, List<String> selectedSubBusiness, List<String> selectedLocation) {
    return _documents.where((data) {
      final businessMatch = selectedBusiness.contains(data.business) || selectedBusiness.contains("All");
      final subBusinessMatch = selectedSubBusiness.contains(data.subBusiness) || selectedSubBusiness.contains("All");
      final locationMatch = selectedLocation.contains(data.location) || selectedLocation.contains("All");
      return businessMatch && subBusinessMatch && locationMatch;
    }).toList();
  }

  dynamic _getValue(WaterUsageRecord document, int columnIndex) {
    switch (columnIndex) {
      case 0:
        return document.date;
      case 1:
        return document.business;
      case 2:
        return document.subBusiness;
      case 3:
        return document.location;
      case 4:
        return document.waterUsage;
      default:
        return null;
    }
  }

  List<List<dynamic>> _createList(List<WaterUsageRecord> input) {
    final List<List<dynamic>> data = [
      [
        'Date',
        'Business',
        'SubBusiness',
        'Location',
        'Area',
        'WaterUsage'
      ]
    ];

    for(var temp in input){
      List<String> row = [
        temp.date,
        temp.business,
        temp.subBusiness,
        temp.location,
        temp.waterUsage
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
      _fetchDocumentsAdmin();
    }
    else{
      _fetchDocuments();
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
                        _fetchDocumentsAdmin();
                      }
                      else{
                        _fetchDocuments();
                      }
                    }
                    else if(value == 1){
                      exportExcel(context, _createList(_documents));
                    }
                  }
              ),
            ],
            elevation: 2,
            backgroundColor: Colors.white,
          ),
          drawer: Drawer(
          // Add your menu items inside the Drawer
          width: 400,
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
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Select Business', style: TextStyle(fontSize: 15, color: Colors.black),),
                    Container(height: 10,),
                    DropDownMultiSelect(
                        options: business.toList(),
                        selectedValues: selectedBusiness,
                        onChanged: (value){
                          setState(() {
                            if(value.contains('All')){
                              selectedBusiness=business.toList();
                            }
                            selectedBusiness = value;
                          });
                        }
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Select Sub-Business', style: TextStyle(fontSize: 15, color: Colors.black),),
                    Container(height: 10,),
                    DropDownMultiSelect(
                        options: subBusiness.toList(),
                        selectedValues: selectedSubBusiness,
                        onChanged: (value){
                          setState(() {
                            if(value.contains('All')){
                              selectedSubBusiness=subBusiness.toList();
                            }
                            selectedSubBusiness = value;
                          });
                        }
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Select Location', style: TextStyle(fontSize: 15, color: Colors.black),),
                    Container(height: 10,),
                    DropDownMultiSelect(
                        options: location.toList(),
                        selectedValues: selectedLocation,
                        onChanged: (value){
                          setState(() {
                            if(value.contains('All')){
                              selectedLocation=location.toList();
                            }
                            selectedLocation = value;
                          });
                        }
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  child: const Text("Submit"),
                  onPressed: (){
                    setState(() {
                      _data=RecordData(filterData(selectedBusiness, selectedSubBusiness, selectedLocation));
                    });
                    _scaffoldKey.currentState?.closeDrawer();
                  },
                ),
              )
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
                              MaterialPageRoute(
                                  builder: (context) => const WaterUsage()
                              )
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
                               ]
                           )
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
                      columns: [
                        DataColumn(
                            label: const Text('Sr. No' , style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            onSort: (columnIndex, ascending){
                              setState(() {
                                _sortAscending=!_sortAscending;
                              });
                            }
                        ),
                        DataColumn(
                            label: const Text('Submitted On' , style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            onSort: (columnIndex, ascending){
                              setState(() {
                                _sortAscending=!_sortAscending;
                              });
                            }
                        ),
                        DataColumn(
                          label: const Text('Business', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            onSort: (columnIndex, ascending){
                              setState(() {
                                _sortAscending=!_sortAscending;
                              });
                            }
                        ),
                        DataColumn(
                          label: const Text('Sub-Business', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            onSort: (columnIndex, ascending){
                              setState(() {
                                _sortAscending=!_sortAscending;
                              });
                            }
                        ),
                        DataColumn(
                          label: const Text('Location', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            onSort: (columnIndex, ascending){
                              setState(() {
                                _sortAscending=!_sortAscending;
                              });
                            }
                        ),
                        DataColumn(
                          label: const Text('Water Usage', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            onSort: (columnIndex, ascending){
                              setState(() {
                                _sortAscending=!_sortAscending;
                              });
                            }
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

  @override
  void dispose() {
    // Reset system overlay settings
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

}

class RecordData extends DataTableSource{

  int serialNo=1;

  List<Map<String, dynamic>> _data = List.generate(
      1,
          (index) => {
        "Sr. No" : "Sr. No",
        "SubmittedOn": "Submitted On",
        "Business": "Business",
        "SubBusiness": "Sub-Business",
        "Location" : "Location",
        "WaterUsage": "Water Usage"
      });

  RecordData(List<WaterUsageRecord> temp){
    _data = List.generate(
        temp.length,
            (index) => {
          "Sr. No" : (serialNo++).toString(),
          "SubmittedOn": temp[index].time,
          "Business": temp[index].business,
          "SubBusiness": temp[index].subBusiness,
          "Location": temp[index].location,
          "WaterUsage": temp[index].waterUsage
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
      DataCell(Text(_data[index]["SubmittedOn"])),
      DataCell(Text(_data[index]["Business"])),
      DataCell(Text(_data[index]["SubBusiness"])),
      DataCell(Text(_data[index]["Location"])),
      DataCell(Text(_data[index]["WaterUsage"].toString())),
    ]);
  }
}