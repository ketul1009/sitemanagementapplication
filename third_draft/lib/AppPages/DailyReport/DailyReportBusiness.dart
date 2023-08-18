import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:second_draft/AppPages/DailyReport/GeneralPage.dart';
import 'package:second_draft/Common/BusinessSelector.dart';
import 'package:second_draft/Models/DailyReport.dart';
import 'package:second_draft/main.dart';

import '../../Common/CustomDrawer.dart';

class DailyReportBusiness extends StatefulWidget{

  const DailyReportBusiness({super.key});
  @override
  State<DailyReportBusiness> createState() => _DailyReportBusinessState();

}

class _DailyReportBusinessState extends State<DailyReportBusiness>{

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
    ReportProvider reportProvider = context.watch<ReportProvider>();
    Report report = reportProvider.report;
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
                      report.generalInfo.business = map['selectedBusiness']!;
                      report.generalInfo.subBusiness = map['selectedSubBusiness']!;
                      report.generalInfo.location = map['selectedLocation']!;
                      reportProvider.setReport(report);
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GeneralPage())
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