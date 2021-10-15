import 'dart:io';

import 'package:sam_rider_app/driver_src/models/weight.dart';

class Driver {
  String _firstName;
  String _lastName;
  String _dob;
  String _streetAddress;
  String _apt;
  String _city;
  String _state;
  String _zip;
  String _licenseNumber;
  String _licenseState;
  String _licenseDate;
  String _vehicleColor;
  String _vehicleType;
  File _licenseFront;
  File _licenseBack;
  File _driverImage;
  List<String> _prefferedLabour;

  Driver(
      this._firstName,
      this._lastName,
      this._dob,
      this._streetAddress,
      this._apt,
      this._city,
      this._state,
      this._zip,
      this._licenseNumber,
      this._licenseState,
      this._licenseDate,
      this._vehicleColor,
      this._vehicleType);

  String get firstName => _firstName;

  String get lastName => _lastName;

  String get dob => _dob;

  String get streetAddress => _streetAddress;

  String get apartment => _apt;

  String get city => _city;

  String get state => _state;

  String get zip => _zip;

  String get licenseNumber => _licenseNumber;

  String get licenseState => _licenseState;

  String get licenseDate => _licenseDate;

  String get vehicleColor => _vehicleColor;

  String get vehicleType => _vehicleType;

  File get licenseFront => _licenseFront;

  File get licenseBack => _licenseBack;

  File get driverImage => _driverImage;

  List<String> get preferredLabour => _prefferedLabour;

  set licenseNumber(String licenseNumber) => this._licenseNumber = licenseNumber;

  set licenseState(String licenseState) => this._licenseState = licenseState;

  set licenseDate(String licenseDate) => this._licenseDate = licenseDate;

  set vehicleColor(String vehicleColor) => this._vehicleColor = vehicleColor;

  set vehicleType(String vehicleType) => this._vehicleType = vehicleType;

  set licenseFront(File licenseFront) => this._licenseFront = licenseFront;

  set licenseBack(File licenseBack) => this._licenseBack = licenseBack;

  set driverImage(File driverImage) => this._driverImage = driverImage;

  set prefferedLabour(List<String> prefferedLabour) => this._prefferedLabour = prefferedLabour;

}
