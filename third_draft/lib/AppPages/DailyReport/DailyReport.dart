import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_draft/Models/Report.dart';
import 'package:second_draft/AppPages/DailyReport/GeneralPage.dart';

class DailyReport extends StatelessWidget{
  const DailyReport({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReportProvider>(
      create: (context) => ReportProvider(Report("", "", "", GeneralInfo('', '', '', '', ''), EnvironmentInfo('','','',''), ManpowerInfo('','','','','','',''), '')),
      child: MaterialApp(
        home: GeneralPage(),
      ),
    );
  }
}