import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sam_rider_app/driver_src/blocs/auth_bloc.dart';
import 'package:sam_rider_app/driver_src/models/driver.dart';
import 'package:sam_rider_app/driver_src/util/utils.dart';

class Driver_DriverInfoPage extends StatefulWidget {
  @override
  _DriverInfoState createState() => _DriverInfoState();
}

class _DriverInfoState extends State<Driver_DriverInfoPage> {
  AuthBloc authBloc = AuthBloc();
  Driver driver;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _streetAddressController = TextEditingController();
  TextEditingController _aptController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _zipController = TextEditingController();

  String dropdownValue = 'AK';
  List<String> states = [
    'AK',
    'AL',
    'AR',
    'AS',
    'AZ',
    'CA',
    'CO',
    'CT',
    'DC',
    'DE',
    'FL',
    'GA',
    'GU',
    'HI',
    'IA',
    'ID',
    'IL',
    'IN',
    'KS',
    'KY',
    'LA',
    'MA',
    'MD',
    'ME',
    'MI',
    'MN',
    'MO',
    'MP',
    'MS',
    'MT',
    'NC',
    'ND',
    'NE',
    'NH',
    'NJ',
    'NM',
    'NV',
    'NY',
    'OH',
    'OK',
    'OR',
    'PA',
    'PR',
    'RI',
    'SC',
    'SD',
    'TN',
    'TX',
    'UM',
    'UT',
    'VA',
    'VI',
    'VT',
    'WA',
    'WI',
    'WV',
    'WY'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                "Basic Information",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: AppColors.main),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Enter the information exactly as it appears on your drivers license",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'RobotoMono',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: authBloc.firstNameStream,
                builder: (context, snapshot) => TextField(
                    controller: _firstNameController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        //border: InputBorder.none,
                        labelText: "First Name",
                        labelStyle: TextStyle(fontSize: 20))),
              ),
              StreamBuilder(
                stream: authBloc.lastNameStream,
                builder: (context, snapshot) => TextField(
                    controller: _lastNameController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        labelText: "Last Name",
                        labelStyle: TextStyle(fontSize: 20))),
              ),
              StreamBuilder(
                stream: authBloc.dobStream,
                builder: (context, snapshot) => TextField(
                    controller: _dobController,
                    style: TextStyle(fontSize: 18),
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        labelText: "Date of Birth",
                        labelStyle: TextStyle(fontSize: 20))),
              ),
              StreamBuilder(
                stream: authBloc.streetAddressStream,
                builder: (context, snapshot) => TextField(
                    controller: _streetAddressController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        labelText: "Street Address",
                        labelStyle: TextStyle(fontSize: 20))),
              ),
              StreamBuilder(
                stream: authBloc.aptStream,
                builder: (context, snapshot) => TextField(
                    controller: _aptController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        labelText: "Apt,Suite,Bldg (optional)",
                        labelStyle: TextStyle(fontSize: 20))),
              ),
              StreamBuilder(
                stream: authBloc.cityStream,
                builder: (context, snapshot) => TextField(
                    controller: _cityController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        labelText: "City",
                        labelStyle: TextStyle(fontSize: 20))),
              ),
              Row(
                children: [
                  Expanded(
                    child: StreamBuilder(
                        stream: authBloc.stateStream,
                        builder: (context, snapshot) => DropdownButtonFormField(
                              decoration: InputDecoration(
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  labelText: "State",
                                  labelStyle: TextStyle(fontSize: 20)),
                              value: dropdownValue,
                              items: states.map((String items) {
                                return DropdownMenuItem(
                                  child: Text(items),
                                  value: items,
                                );
                              }).toList(),
                              onChanged: (selected) {
                                setState(() {
                                  dropdownValue = selected;
                                });
                                _stateController.value = TextEditingValue(
                                  text: selected,
                                );
                              },
                            )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: authBloc.zipStream,
                      builder: (context, snapshot) => TextField(
                          controller: _zipController,
                          style: TextStyle(fontSize: 18),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              labelText: "Zip",
                              labelStyle: TextStyle(fontSize: 20))),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RawMaterialButton(
                    fillColor: Color.fromRGBO(255, 184, 0, 1),
                    elevation: 5.0,
                    onPressed: () {
                      nextStep();
                    },
                    child: Text(
                      "NEXT",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(26))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateFormat formatter =
        DateFormat('dd/MM/yyyy'); //specifies day/month/year format

    final DateTime picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100),
        initialDate: DateTime.now());
    if (picked != null)
      setState(() {
        _dobController.value = TextEditingValue(
            text: formatter.format(
                picked)); //Use formatter to format selected date and assign to text field
      });
  }

  void nextStep() {
    if (authBloc.isValidDriver(
        _firstNameController.text,
        _lastNameController.text,
        _dobController.text,
        _streetAddressController.text,
        _cityController.text,
        _stateController.text,
        _zipController.text)) {

      driver = new Driver(
          _firstNameController.text,
          _lastNameController.text,
          _dobController.text,
          _streetAddressController.text,
          _aptController.text,
          _cityController.text,
          _stateController.text,
          _zipController.text,null,null,null,null,null);

      Navigator.pushNamed(context, '/license_info', arguments: driver);
    }
  }
}
