import 'package:flutter/cupertino.dart';

class TreePlantationReport{

  String userId;
  String reportId;
  String time;
  String business;
  String subBusiness;
  String location;
  String month;
  String year;
  String treeNumber;
  String comments;

  TreePlantationReport(this.userId, this.reportId, this.time, this.business, this.subBusiness, this.location, this.month, this.year, this.treeNumber, this.comments);
}

class TreeReportProvider with ChangeNotifier{
  TreePlantationReport _treePlantationReport;

  TreeReportProvider(this._treePlantationReport);

  TreePlantationReport get treePlantationReport => _treePlantationReport;

  void setReport(TreePlantationReport treePlantationReport){
    _treePlantationReport = treePlantationReport;
    notifyListeners();
  }
}