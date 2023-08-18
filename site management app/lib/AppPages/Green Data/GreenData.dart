import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_draft/Models/GreenDataRecord.dart';

import 'GreenDataGeneralPage.dart';

class GreenData extends StatelessWidget{
  const GreenData({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GreenDataProvider>(
      create: (context) => GreenDataProvider(GreenDataRecord('', '', '', '', '', '', '', '', '', [])),
      child: const MaterialApp(
        home: GreenDataGeneralPage(),
      ),
    );
  }
}