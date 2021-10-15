import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sam_rider_app/driver_src/blocs/data_bloc.dart';
import 'package:sam_rider_app/driver_src/models/driver.dart';
import 'package:sam_rider_app/driver_src/ui/widgets/msg_dialog.dart';
import 'package:sam_rider_app/driver_src/util/utils.dart';

class Driver_FinalRegistrationPage extends StatefulWidget {


  @override
  _FinalRegistrationPageState createState() => _FinalRegistrationPageState();
}

class _FinalRegistrationPageState extends State<Driver_FinalRegistrationPage> {
  DataBloc dataBloc = new DataBloc();
  final picker = ImagePicker();
  Driver driver;
  final logo = Padding(
    padding: EdgeInsets.only(
      bottom: 50,
    ),
    child: Container(
      height: 200.0,
      width: 200.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AvailableImages.appLogo1,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    driver = ModalRoute.of(context).settings.arguments;
    uploadData();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            //constraints: BoxConstraints.expand(),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  logo,
                  Text(
                    "Just a Second...",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: AppColors.main),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'We need to upload your data',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Icon(Icons.arrow_circle_up_sharp),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Submitting Images...',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(Icons.arrow_circle_up_sharp),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Checking Documents...',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(Icons.arrow_circle_up_sharp),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Verifying Authenticity...',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void uploadData() {
    // print(driver.licenseFront);
    // print(driver.licenseBack);
    // print(driver.driverImage);

    dataBloc.setDriver(driver, (){
      Navigator.pushNamed(context, '/driver_home');
    }, (String msg){
      MsgDialog.showMsgDialog(context, "Registration", msg);
     // Navigator.pushNamed(context, '/driver_signup');
    });
  }
}
