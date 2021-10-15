import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sam_rider_app/driver_src/models/driver.dart';
import 'package:sam_rider_app/driver_src/util/utils.dart';

class Driver_LicenseImageFrontPage extends StatefulWidget {
  @override
  _LicenseImagePageState createState() => _LicenseImagePageState();
}

class _LicenseImagePageState extends State<Driver_LicenseImageFrontPage> {
  File _frontImage;
  File _backImage;
  final picker = ImagePicker();
  bool front = true;
  Driver driver;

  @override
  Widget build(BuildContext context) {
    driver = ModalRoute.of(context).settings.arguments as Driver;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            //constraints: BoxConstraints.expand(),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    front
                        ? "Capture Front Of Driver's License"
                        : "Capture Back Of Driver's License",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: AppColors.main),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Tips',
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
                      Icon(Icons.dark_mode),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Use a dark background',
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
                      Icon(Icons.filter_frames_rounded),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Get all 4 corners within frame',
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
                      Icon(Icons.lightbulb),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Use a well-lit area',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Tap \"I\'m Ready\" once you have your license in front of you',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
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
                          takePicture();
                        },
                        child: Text(
                          "I'm Ready",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(26))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> takePicture() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (pickedFile != null) {
      if (front) {
        _frontImage = File(pickedFile.path);
        setState(() {
          front = false;
        });
      } else {
        _backImage = File(pickedFile.path);
        nextPage();
      }
    } else {
      print('No image selected.');
    }
    // setState(() {
    //   Navigator.pop(context, "camera");
    // });
  }

  void nextPage() {
    driver.licenseFront=File(_frontImage.path);
    driver.licenseBack=File(_backImage.path);
    Navigator.pushNamed(context, '/driver_picture', arguments: driver);
  }
}
