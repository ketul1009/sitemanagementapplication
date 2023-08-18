import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_draft/AppPages/MillionTrees/TreeMissionGeneralPage.dart';
import 'package:second_draft/AppPages/Water%20Usage/RecordPage.dart';
import 'package:second_draft/AppPages/Water%20Usage/WaterUsageGeneralPage.dart';
import 'package:second_draft/Models/TreePlantationReport.dart';
import 'package:second_draft/Models/WaterUsageRecord.dart';


class TreeMission extends StatelessWidget{
  const TreeMission({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TreeReportProvider>(
      create: (context) => TreeReportProvider(TreePlantationReport('', '', '', '', '', '', '', '', '', '')),
      child: const MaterialApp(
        home: TreeMissionGeneralPage(),
      ),
    );
  }
}