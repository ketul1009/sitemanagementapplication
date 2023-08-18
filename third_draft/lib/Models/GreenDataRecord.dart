import 'package:flutter/cupertino.dart';

class GreenDataRecord{

  String preparedBy;
  String reportId;
  String time;
  String business;
  String subBusiness;
  String location;
  String subLocation;
  String site;
  String greenZone;
  List<SpeciesData> data;

  GreenDataRecord(this.preparedBy, this.reportId, this.time, this.business, this.subBusiness, this.location, this.subLocation, this.site, this.greenZone, this.data);

}

class SpeciesData{
  String greenZone;
  String type;
  String species;
  String quantity;
  String area;
  String date;

  SpeciesData(this.greenZone, this.type, this.species, this.quantity, this.area, this.date);
}

class GreenDataProvider with ChangeNotifier{
  GreenDataRecord _greenDataRecord;

  GreenDataProvider(this._greenDataRecord);

  GreenDataRecord get greenDataRecord => _greenDataRecord;

  void setReport(GreenDataRecord greenDataRecord){
    _greenDataRecord = greenDataRecord;
    notifyListeners();
  }
}