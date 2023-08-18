import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_draft/AppPages/Green%20Data/GreenDataSubmission.dart';
import 'package:second_draft/Common/BusinessSelector.dart';
import 'package:second_draft/Models/GreenDataRecord.dart';
import '../../Common/CustomDrawer.dart';
import '../../Common/DateAndTimePicker.dart';
import '../../Constants/GeneralData.dart';
import '../LoginPage.dart';
import 'package:second_draft/main.dart';

class GreenDataGeneralPage extends StatefulWidget{
  const GreenDataGeneralPage({super.key});

  @override
  State<GreenDataGeneralPage> createState() => GreenDataGeneralPageState();
}

class GreenDataGeneralPageState extends State<GreenDataGeneralPage>{
  List<String> businesses = ['Business'] + business.keys.toList();
  List<String> subBusinesses = ['Sub-Business'] + subBusiness['Business'];
  List<String> locations = ['Location'];
  String selectedBusiness = "Business";
  String selectedSubBusiness = "Sub-Business";
  String selectedLocation = "Location";
  String date="";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  String receivedData = "";

  @override
  Widget build(BuildContext context){
    GreenDataProvider greenDataProvider = context.watch<GreenDataProvider>();
    GreenDataRecord greenDataRecord = greenDataProvider.greenDataRecord;
    return WillPopScope(
        onWillPop: () async {
          if(!drawerOpen) {
            Navigator.of(context).pop();
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
            elevation: 2,
            backgroundColor: Colors.white,
          ),
          drawer: const CustomDrawer(),
          body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(height: 30,),
                  BusinessSelector(
                      onDataSubmitted: (Map<String, String> map){
                        greenDataRecord.business = map['selectedBusiness']!;
                        greenDataRecord.subBusiness = map['selectedSubBusiness']!;
                        greenDataRecord.location = map['selectedLocation']!;
                        greenDataProvider.setReport(greenDataRecord);
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const GreenDataSubmissionPage())
                        );
                      }
                  )
                ],
              )
          ),
    ));
  }
}