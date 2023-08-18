import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:random_string/random_string.dart';
import 'package:second_draft/AppPages/Water%20Usage/WaterUsageSubmissionPage.dart';
import 'package:second_draft/Common/BusinessSelector.dart';
import 'package:second_draft/Models/WaterUsageRecord.dart';
import '../../Common/CustomDrawer.dart';
import '../LoginPage.dart';
import 'package:second_draft/main.dart';

class WaterUsageGeneralPage extends StatefulWidget{

  const WaterUsageGeneralPage({super.key});
  @override
  State<WaterUsageGeneralPage> createState() => _WaterUsageGeneralPageState();

}

class _WaterUsageGeneralPageState extends State<WaterUsageGeneralPage>{

  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = false;
  bool error=false;

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
  }

  @override
  Widget build(BuildContext context){
    WaterRecordProvider waterRecordProvider = context.watch<WaterRecordProvider>();
    WaterUsageRecord waterUsageRecord = waterRecordProvider.greenDataRecord;
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
                  BusinessSelector(
                      onDataSubmitted: (Map<String, String> map){
                        waterUsageRecord.business = map['selectedBusiness']!;
                        waterUsageRecord.subBusiness = map['selectedSubBusiness']!;
                        waterUsageRecord.location = map['selectedLocation']!;
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const WaterUsageSubmissionPage())
                        );
                  }),
            ],
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
