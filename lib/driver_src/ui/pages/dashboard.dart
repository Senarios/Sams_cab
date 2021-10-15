import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_panel/flip_panel.dart';
import 'package:flutter/material.dart';
import 'package:sam_rider_app/driver_src/util/Constants.dart';
import 'package:sam_rider_app/src/blocs/auth_bloc.dart';
import 'package:sam_rider_app/src/ui/pages/job_location_pick.dart';
import 'package:sam_rider_app/src/ui/widgets/msg_dialog.dart';
import 'package:sam_rider_app/src/util/utils.dart';

// ignore: must_be_immutable
class DashboardPage extends StatelessWidget {
  AuthBloc authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    final logo = Padding(
      padding: EdgeInsets.only(
        bottom: 80,
      ),
      child: Container(
        height: 200.0,
        width: 200.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AvailableImages.baseLogo,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    final nextBtn = InkWell(
      onTap: () => {moveToNext(context)},
      child: Container(
        height: 60.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white),
          color: Colors.transparent,
        ),
        child: Stack(
          children: <Widget>[],
        ),
      ),
    );
    final buttons = Padding(
      padding: EdgeInsets.only(
        top: 80.0,
        bottom: 30.0,
        left: 30.0,
        right: 30.0,
      ),
      child: Column(
        children: <Widget>[nextBtn],
      ),
    );

    final headingText = Padding(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 35.0),
      child: Material(
        //Wrap with Material
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.001)),
        elevation: 18.0,
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        // Add This
        child: Text(' Please choose type of Account ...',
            style: new TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final regularUserButton = Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 15.0),
      child: Material(
        //Wrap with Material
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 18.0,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        // Add This
        child: MaterialButton(
          minWidth: 250.0,
          height: 45,
          color: Colors.white, //Color(0xFF801E48),
          child: new Text('I am a regular User',
              style: new TextStyle(fontSize: 16.0, color: Colors.green)),
          onPressed: () {
          //  Constants.prefs.setString("USER_TYPE", "RIDER");
            Navigator.pushNamed(context, '/rider_welcome');
//          setState(() {
//            _isNeedHelp = true;
//          });
          },
        ),
      ),
    );

    final driverButton = Padding(
      padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: Material(
        //Wrap with Material
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 18.0,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        // Add This
        child: MaterialButton(
          minWidth: 250.0,
          height: 45,
          color: Colors.white, //Color(0xFF801E48),
          child: new Text('I am a Driver',
              style: new TextStyle(fontSize: 16.0, color: Colors.green)),
          onPressed: () {
           // Constants.prefs.setString("USER_TYPE", "DRIVER");
            Navigator.pushNamed(context, '/driver_welcome');
//          setState(() {
//            _isNeedHelp = true;
//          });
          },
        ),
      ),
    );

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(34, 178, 76, 1),
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //   image: AvailableImages.bgWelcome,
        //   fit: BoxFit.cover,
        // )),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 70.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  headingText,
                  logo,
                  regularUserButton,
                  driverButton,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void moveToNext(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushNamed(context, '/intro');
    } else {
      print("check phone number");
      onCheckVerifiedPhone(context);
    }
  }

  void onCheckVerifiedPhone(context) {
    authBloc.checkVerifyPhone((result) {
      if (result == "error") {
        Navigator.pushNamed(context, '/intro');
      } else if (result == "success") {
        // Navigator.of(context).push(MaterialPageRoute(settings: RouteSettings(name: '/joblocation'), builder: (context) => JobLocationPickPage()));
        Navigator.pushNamed(context, '/joblocation');
      } else {
        // Navigator.of(context).push(MaterialPageRoute(settings: RouteSettings(name: '/joblocation'), builder: (context) => JobLocationPickPage()));
        Navigator.pushNamed(context, '/joblocation');
        print("verifiy phone number");
        //TODO: should be configuration APN on apple developer
        // onVerifyPhone(context, result);
      }
    });
  }

  void onVerifyPhone(context, String phone) {
    authBloc.verifyPhone("+1$phone", (verificationId) {
      Navigator.pushNamed(context, '/verify_phone', arguments: verificationId);
    }, (error) {
      MsgDialog.showMsgDialog(context, "Verify Phone Number", error.toString());
      FirebaseAuth.instance.signOut();
    });
  }
}
