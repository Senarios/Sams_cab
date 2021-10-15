import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sam_rider_app/driver_src/models/driver.dart';
import 'package:sam_rider_app/driver_src/ui/widgets/msg_dialog.dart';
import 'package:sam_rider_app/driver_src/util/utils.dart';

class Driver_DriverImagePage extends StatefulWidget {
  @override
  _DriverPictureState createState() => _DriverPictureState();
}

class _DriverPictureState extends State<Driver_DriverImagePage> {
  File _image;
  final picker = ImagePicker();
  Driver driver;

  @override
  Widget build(BuildContext context) {
    driver = ModalRoute.of(context).settings.arguments as Driver;
    print(driver);
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
                  Text(
                    "Take a Selfie",
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
                      Icon(Icons.person),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Make sure your face is visible',
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
                      Icon(Icons.not_interested),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'No masks or hats',
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
      _image = File(pickedFile.path);
      final inputImage = InputImage.fromFile(_image);
      final faceDetector = GoogleMlKit.vision.faceDetector();
      await faceDetector.processImage(inputImage).then((faces) {
        if (faces.length == 1) {
          print("Face Detected");
          print(_image.path);
          driver.driverImage=File(_image.path);
          Navigator.pushNamed(context, '/register_final',
              arguments: driver);
        } else if (faces.length == 0) {
          MsgDialog.showMsgDialog(context, "Take a Selfie", "No face Detected");
        } else {
          MsgDialog.showMsgDialog(
              context, "Take a Selfie", "Make sure to include your face only");
        }
      });
    } else {
      print('No image selected.');
    }
    // setState(() {
    //   Navigator.pop(context, "camera");
    // });
  }
}
