// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_draft/AppPages/DailyReport/DailyReportBusiness.dart';
import 'package:second_draft/Models/DailyReport.dart';
import 'package:second_draft/AppPages/DailyReport/GeneralPage.dart';

class DailyReport extends StatelessWidget{
  const DailyReport({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReportProvider>(
      create: (context) => ReportProvider(Report("", "", "", GeneralInfo('', '', '', '', '', ''), EnvironmentInfo('','','',''), ManpowerInfo('','','','','','',''), '')),
      child: const MaterialApp(
        home: DailyReportBusiness(),
      ),
    );
  }
}