import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sam_rider_app/driver_src/blocs/auth_bloc.dart';
import 'package:sam_rider_app/driver_src/models/driver.dart';
import 'package:sam_rider_app/driver_src/models/weight.dart';
import 'package:sam_rider_app/driver_src/util/globals.dart';
import 'package:sam_rider_app/driver_src/util/utils.dart';

class Driver_LicenseInfoPage extends StatefulWidget {
  @override
  _VehicleInfoPageState createState() => _VehicleInfoPageState();
}

class _VehicleInfoPageState extends State<Driver_LicenseInfoPage> {
  AuthBloc authBloc = AuthBloc();

  TextEditingController _licenseNumberController = TextEditingController();
  TextEditingController _licenseStateController = TextEditingController();
  TextEditingController _licenseDateController = TextEditingController();
  TextEditingController _vehicleColorController = TextEditingController();
  TextEditingController _vehicleTypeController = TextEditingController();

  String dropdownStateValue = 'AK';
  String dropdownVehicleTypeValue = 'Automobile';
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
  Driver driver;
  List<String> _weights=[];
  List<String> _items = [];
  var itemsToShow;
  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    driver = ModalRoute.of(context).settings.arguments as Driver;

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
                "Driving Information",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: AppColors.main),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Provide your license & vehicle information",
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
                stream: authBloc.licenseNumberStream,
                builder: (context, snapshot) => TextField(
                    controller: _licenseNumberController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        //border: InputBorder.none,
                        labelText: "Driver's License Number",
                        labelStyle: TextStyle(fontSize: 20))),
              ),
              StreamBuilder(
                  stream: authBloc.licenseStateStream,
                  builder: (context, snapshot) => DropdownButtonFormField(
                        decoration: InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            labelText: "State",
                            labelStyle: TextStyle(fontSize: 20)),
                        value: dropdownStateValue,
                        items: states.map((String items) {
                          return DropdownMenuItem(
                            child: Text(items),
                            value: items,
                          );
                        }).toList(),
                        onChanged: (selected) {
                          setState(() {
                            dropdownStateValue = selected;
                          });
                          _licenseStateController.value = TextEditingValue(
                            text: selected,
                          );
                        },
                      )),
              StreamBuilder(
                stream: authBloc.licenseDateStream,
                builder: (context, snapshot) => TextField(
                    controller: _licenseDateController,
                    style: TextStyle(fontSize: 18),
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        labelText: "Issue Date",
                        labelStyle: TextStyle(fontSize: 20))),
              ),
              StreamBuilder(
                stream: authBloc.vehicleColorStream,
                builder: (context, snapshot) => TextField(
                    controller: _vehicleColorController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        labelText: "Vehicle Color",
                        labelStyle: TextStyle(fontSize: 20))),
              ),
              StreamBuilder(
                  stream: authBloc.vehicleTypeStream,
                  builder: (context, snapshot) => DropdownButtonFormField(
                        decoration: InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            labelText: "Vehicle type",
                            labelStyle: TextStyle(fontSize: 20)),
                        value: dropdownVehicleTypeValue,
                        items: Globals.carNames.map((String items) {
                          return DropdownMenuItem(
                            child: Text(items),
                            value: items,
                          );
                        }).toList(),
                        onChanged: (selected) {
                          setState(() {
                            dropdownVehicleTypeValue = selected;
                          });
                          _vehicleTypeController.value = TextEditingValue(
                            text: selected,
                          );
                        },
                      )),
              SizedBox(
                height: 10,
              ),
              MultiSelectDialogField(
                  key: _multiSelectKey,
                  validator: (values) {
                    if (values == null || values.isEmpty) {
                      return "Add your Preffered Labor";
                    }
                    return null;
                  },
                  selectedColor: AppColors.main,
                  items: itemsToShow,
                  title: Text("Labor"),
                  buttonText: Text("Preffered Labor"),
                  onConfirm: (weights) {
                    _weights.clear();
                    weights.forEach((element) {
                      _weights.add(element);
                    });
                  }),
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
        _licenseDateController.value = TextEditingValue(
            text: formatter.format(
                picked)); //Use formatter to format selected date and assign to text field
      });
  }

  void nextStep() {
    if (authBloc.isValidLicense(
            _licenseNumberController.text,
            _licenseStateController.text,
            _licenseDateController.text,
            _vehicleColorController.text,
            _vehicleTypeController.text) &&
        _multiSelectKey.currentState.validate()) {
      driver.licenseNumber = _licenseNumberController.text;
      driver.licenseState = _licenseStateController.text;
      driver.licenseDate = _licenseDateController.text;
      driver.vehicleType = _vehicleTypeController.text;
      driver.vehicleColor = _vehicleColorController.text;
      driver.prefferedLabour = _weights;
      Navigator.pushNamed(context, '/license_picture', arguments: driver);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Globals.labourTitles.forEach((value) {
      _items.add(value);
    });
    itemsToShow = _items
        .map((value) => MultiSelectItem<String>(value, value))
        .toList();
    super.initState();
  }
}
