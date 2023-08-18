import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_draft/AppPages/Water%20Usage/RecordPage.dart';
import 'package:second_draft/AppPages/Water%20Usage/WaterUsageGeneralPage.dart';
import 'package:second_draft/Models/WaterUsageRecord.dart';


class WaterUsage extends StatelessWidget{
  const WaterUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WaterRecordProvider>(
      create: (context) => WaterRecordProvider(WaterUsageRecord('', '', '', '', '', '', '', '', '', '')),
      child: const MaterialApp(
        home: WaterUsageGeneralPage(),
      ),
    );
  }
}