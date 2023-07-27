import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Report{
  String preparedBy;
  String name;
  String reportId;
  GeneralInfo generalInfo;
  EnvironmentInfo environmentInfo;
  ManpowerInfo manpowerInfo;
  String signedBy;

  Report(this.preparedBy, this.name, this.reportId, this.generalInfo, this.environmentInfo, this.manpowerInfo, this.signedBy);
}

class GeneralInfo{

  String date;
  String company;
  String location;
  String contractor;
  String supervisor;

  GeneralInfo(this.date, this.company, this.location, this.contractor, this.supervisor);
}

class EnvironmentInfo{

  String weather;
  String temp;
  String wind;
  String humidity;

  EnvironmentInfo(this.weather, this.temp, this.wind, this.humidity);

}

class ManpowerInfo{

  String skilled;
  String semiSkilled;
  String unskilled;
  String supervisors;
  String irrigationTech;
  String horticulturist;
  String managers;

  ManpowerInfo(this.skilled, this.semiSkilled, this.unskilled, this.supervisors, this.irrigationTech, this.horticulturist, this.managers);
}

class ReportProvider with ChangeNotifier{
  Report _report;

  ReportProvider(this._report);

  Report get report => _report;

  void setReport(Report report){
    _report = report;
    notifyListeners();
  }
}