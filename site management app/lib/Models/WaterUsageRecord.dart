import 'package:flutter/cupertino.dart';

class WaterUsageRecord{

  String userId;
  String reportId;
  String time;
  String business;
  String subBusiness;
  String location;
  String date;
  String area;
  String weather;
  String waterUsage;

  WaterUsageRecord(this.userId, this.reportId, this.time, this.business, this.subBusiness, this.location ,this.date, this.area, this.weather, this.waterUsage);
  
}

class WaterRecordProvider with ChangeNotifier{
  WaterUsageRecord _waterUsageRecord;

  WaterRecordProvider(this._waterUsageRecord);

  WaterUsageRecord get greenDataRecord => _waterUsageRecord;

  void setReport(WaterUsageRecord waterUsageRecord){
    _waterUsageRecord = waterUsageRecord;
    notifyListeners();
  }
}