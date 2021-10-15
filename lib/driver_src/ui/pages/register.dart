import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sam_rider_app/driver_src/blocs/auth_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:sam_rider_app/driver_src/ui/widgets/loading_dialog.dart';
import 'package:sam_rider_app/driver_src/ui/widgets/msg_dialog.dart';
import 'package:sam_rider_app/driver_src/util/utils.dart';

class Driver_RegisterPage extends StatefulWidget {
  Driver_RegisterPage({Key key}) : super(key: key);

  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Driver_RegisterPage> {
  AuthBloc authBloc = AuthBloc();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

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
                height: 100,
              ),
              Container(
                height: 130.0,
                width: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AvailableImages.appLogo1,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 10),
                child: StreamBuilder(
                  stream: authBloc.nameStream,
                  builder: (context, snapshot) => TextField(
                      controller: _nameController,
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          errorText: snapshot.hasError ? snapshot.error : null,
                          border: InputBorder.none,
                          labelText: "Name",
                          prefixIcon: Container(
                            width: 50,
                            child: Icon(Icons.person),
                          ),
                          labelStyle: TextStyle(fontSize: 20))),
                ),
              ),
              StreamBuilder(
                stream: authBloc.phoneStream,
                builder: (context, snapshot) => TextField(
                    controller: _phoneController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        border: InputBorder.none,
                        labelText: "Phone Number",
                        prefixIcon: Container(
                          width: 50,
                          child: Icon(Icons.phone),
                        ),
                        labelStyle: TextStyle(fontSize: 20))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: StreamBuilder(
                  stream: authBloc.emailStram,
                  builder: (context, snapshot) => TextField(
                      controller: _emailController,
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          errorText: snapshot.hasError ? snapshot.error : null,
                          border: InputBorder.none,
                          labelText: "Email",
                          prefixIcon: Container(
                            width: 50,
                            child: Icon(Icons.email),
                          ),
                          labelStyle: TextStyle(fontSize: 20))),
                ),
              ),
              StreamBuilder(
                stream: authBloc.passStream,
                builder: (context, snapshot) => TextField(
                    controller: _passController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        border: InputBorder.none,
                        labelText: "Password",
                        prefixIcon: Container(
                          width: 50,
                          child: Icon(Icons.security),
                        ),
                        labelStyle: TextStyle(fontSize: 20))),
              ),
              // StreamBuilder(
              //   stream: authBloc.carMakeStream,
              //   builder: (context, snapshot) => TextField(
              //       controller: _carMakeController,
              //       style: TextStyle(fontSize: 18),
              //       keyboardType: TextInputType.text,
              //       decoration: InputDecoration(
              //           errorText: snapshot.hasError ? snapshot.error : null,
              //           border: InputBorder.none,
              //           labelText: "Make",
              //           prefixIcon: Container(
              //             width: 50,
              //             child: Icon(Icons.query_builder),
              //           ),
              //           labelStyle: TextStyle(fontSize: 20))),
              // ),
              // StreamBuilder(
              //   stream: authBloc.carModelStream,
              //   builder: (context, snapshot) => TextField(
              //       controller: _carModelController,
              //       style: TextStyle(fontSize: 18),
              //       keyboardType: TextInputType.text,
              //       decoration: InputDecoration(
              //           errorText: snapshot.hasError ? snapshot.error : null,
              //           border: InputBorder.none,
              //           labelText: "Model",
              //           prefixIcon: Container(
              //             width: 50,
              //             child: Icon(Icons.model_training),
              //           ),
              //           labelStyle: TextStyle(fontSize: 20))),
              // ),
              // StreamBuilder(
              //   stream: authBloc.carYearStream,
              //   builder: (context, snapshot) => TextField(
              //       controller: _carYearController,
              //       style: TextStyle(fontSize: 18),
              //       keyboardType: TextInputType.number,
              //       decoration: InputDecoration(
              //           errorText: snapshot.hasError ? snapshot.error : null,
              //           border: InputBorder.none,
              //           labelText: "Year",
              //           prefixIcon: Container(
              //             width: 50,
              //             child: Icon(Icons.build),
              //           ),
              //           labelStyle: TextStyle(fontSize: 20))),
              // ),
              // StreamBuilder(
              //   stream: authBloc.carColorStream,
              //   builder: (context, snapshot) => TextField(
              //       controller: _carColorController,
              //       style: TextStyle(fontSize: 18),
              //       keyboardType: TextInputType.text,
              //       decoration: InputDecoration(
              //           errorText: snapshot.hasError ? snapshot.error : null,
              //           border: InputBorder.none,
              //           labelText: "Car Color",
              //           prefixIcon: Container(
              //             width: 50,
              //             child: Icon(Icons.color_lens),
              //           ),
              //           labelStyle: TextStyle(fontSize: 20))),
              // ),
              // StreamBuilder(
              //   stream: authBloc.carTagStream,
              //   builder: (context, snapshot) => TextField(
              //       controller: _carTagController,
              //       style: TextStyle(fontSize: 18),
              //       keyboardType: TextInputType.text,
              //       decoration: InputDecoration(
              //           errorText: snapshot.hasError ? snapshot.error : null,
              //           border: InputBorder.none,
              //           labelText: "Tag number",
              //           prefixIcon: Container(
              //             width: 50,
              //             child: Icon(Icons.tag),
              //           ),
              //           labelStyle: TextStyle(fontSize: 20))),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RawMaterialButton(
                    fillColor: Color.fromRGBO(255, 184, 0, 1),
                    elevation: 5.0,
                    onPressed: () => _onSignupClicked(),
                    child: Text(
                      "Signup",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(26))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RawMaterialButton(
                    fillColor: Color.fromRGBO(59, 89, 152, 1),
                    elevation: 5.0,
                    onPressed: () => _signUpWithFacebook(),
                    child: Text(
                      "Signup with Facebook",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(26))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RawMaterialButton(
                    fillColor: Colors.white,
                    elevation: 5.0,
                    onPressed: () => _signUpWithGoogle(),
                    child: Text(
                      "Signup with Google",
                      style: TextStyle(color: Colors.black),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(26))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RawMaterialButton(
                    fillColor: Colors.black,
                    elevation: 5.0,
                    onPressed: () => _signUpWithApple(),
                    child: Text(
                      "Signup with Apple",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(26))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a User?',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/driver_login');
                      },
                      child: Text(
                        'Login now',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyAccountDetails(String name) async {
    LoadgingDialog.showLoadingDialog(context, "Loading...");

    setState(() {});

    String valueURL = AppConfig.checkingURL +
        "firstname=" +
        name +
        "&lastname=" +
        name +
        "&apikey=" +
        AppConfig.checkingKey;

    var res = await http.get(Uri.parse(valueURL), headers: null);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      if (data["person"].length == 0) {
        _signUp();
      } else {
        LoadgingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(
            context, "Oops.", "You can't register at this time");
      }
    } else {
      LoadgingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, "Oops.", "Server error");
    }
  }

  void _signUp() {
    var isValid = authBloc.isValid(
        _nameController.text,
        _emailController.text,
        _passController.text,
        _phoneController.text);
    print(isValid);
    if (isValid) {
      // create user
      //loading dialog
       LoadgingDialog.showLoadingDialog(context, "Loading...");
      return authBloc.signUp(
          _emailController.text.trim(),
          _passController.text.trim(),
          _phoneController.text.trim(),
          _nameController.text,
           () {
        LoadgingDialog.hideLoadingDialog(context);
      //  MsgDialog.showMsgDialog(context, "SignUp", "Phone verified");
        verifyPhoneNumber();
      }, (msg) {
        print(msg);
        //show msg dialog
        LoadgingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, "SignUp", msg);
      });
    }
  }

  void verifyPhoneNumber() {
     authBloc.verifyPhone(_phoneController.text, (verificationId)
     {
       Navigator.pushNamed(context, '/verify_number',arguments: verificationId);
     },(error){
       MsgDialog.showMsgDialog(context, "Verify Phone Number", error.toString());
     });
  }

  void _onSignupClicked() {
    //_verifyAccountDetails(_nameController.text);
    _signUp();
  }

  void _signUpWithFacebook() {

    // create user
    // loading dialog
    LoadgingDialog.showLoadingDialog(context, "Loading...");
    return authBloc.signUpWithFacebook(() {
      LoadgingDialog.hideLoadingDialog(context);
      //  onVerifyPhone();
      Navigator.pushNamed(context, '/driver_home');
    }, (msg) {
      print(msg);
      //show msg dialog
      LoadgingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, "SignUp", msg);
    });
  }

  void _signUpWithGoogle()
  {
    // create user
    // loading dialog
    LoadgingDialog.showLoadingDialog(context, "Loading...");
    return authBloc.signUpWithGoogle(() {
      LoadgingDialog.hideLoadingDialog(context);
      //  onVerifyPhone();
      Navigator.pushNamed(context, '/driver_home');
    }, (msg) {
      print(msg);
      //show msg dialog
      LoadgingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, "SignUp", msg);
    });
  }

  void _signUpWithApple()
  {
    // create user
    // loading dialog
    LoadgingDialog.showLoadingDialog(context, "Loading...");
    return authBloc.signUpWithApple(() {
      LoadgingDialog.hideLoadingDialog(context);
      //  onVerifyPhone();
      Navigator.pushNamed(context, '/driver_home');
    }, (msg) {
      print(msg);
      //show msg dialog
      LoadgingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, "SignUp", msg);
    });
  }

}
