import 'dart:async';

import 'package:sam_rider_app/driver_src/firebase/firedataref.dart';


class AuthBloc {
  var _fireAuth = FireDataRef();
  StreamController _nameController = StreamController();
  StreamController _emailController = StreamController();
  StreamController _passController = StreamController();
  StreamController _phoneController = StreamController();
  StreamController _firstNameController = StreamController();
  StreamController _lastNameController = StreamController();
  StreamController _dobController = StreamController();
  StreamController _streetAddressController = StreamController();
  StreamController _aptController = StreamController();
  StreamController _cityController = StreamController();
  StreamController _stateController = StreamController();
  StreamController _zipController = StreamController();
  StreamController _licenseNumberController = StreamController();
  StreamController _licenseStateController = StreamController();
  StreamController _licenseDateController = StreamController();
  StreamController _vehicleColorController = StreamController();
  StreamController _vehicleTypeController = StreamController();

  Stream get nameStream => _nameController.stream;

  Stream get emailStram => _emailController.stream;

  Stream get passStream => _passController.stream;

  Stream get phoneStream => _phoneController.stream;

  Stream get firstNameStream => _firstNameController.stream;

  Stream get lastNameStream => _lastNameController.stream;

  Stream get dobStream => _dobController.stream;

  Stream get streetAddressStream => _streetAddressController.stream;

  Stream get aptStream => _aptController.stream;

  Stream get cityStream => _cityController.stream;

  Stream get stateStream => _stateController.stream;

  Stream get zipStream => _zipController.stream;

  Stream get licenseNumberStream => _licenseNumberController.stream;

  Stream get licenseStateStream => _licenseStateController.stream;

  Stream get licenseDateStream => _licenseDateController.stream;

  Stream get vehicleColorStream => _vehicleColorController.stream;

  Stream get vehicleTypeStream => _vehicleTypeController.stream;


  bool isValid(String name, String email, String pass, String phone) {
    if (name == null || name.length == 0) {
      _nameController.sink.addError("Enter your name");
      return false;
    }
    _nameController.sink.add("");

    if (phone == null || phone.length == 0) {
      _phoneController.sink.addError("Enter your phone number");
      return false;
    }
    _phoneController.sink.add("");

    if (email == null || email.length == 0) {
      _emailController.sink.addError("Enter your email");
      return false;
    }
    _emailController.sink.add("");

    if (pass == null || pass.length < 6) {
      _passController.sink
          .addError("Password must be longer than 6 characters");
      return false;
    }
    _passController.sink.add("");

    return true;
  }

  void verifyPhone(
      String phone, Function(String) onCodeSent, Function(dynamic) onError) {
    _fireAuth.verifyPhone(phone, onCodeSent, onError);
  }

  void connectPhone(String code, String verificationId, Function onCompleted,
      Function onError) {
    _fireAuth.connectPhone(code, verificationId, onCompleted, onError);
  }

  bool isValidDriver(String firstName, String lastName, String dob,
      String streetAddress, String city, String state, String zip) {

    if (firstName == null || firstName.length == 0) {
      _firstNameController.sink.addError("Enter your First Name");
      return false;
    }
    _firstNameController.sink.add("");

    if (lastName == null || lastName.length == 0) {
      _lastNameController.sink.addError("Enter your Last Name");
      return false;
    }
    _lastNameController.sink.add("");

    if (dob == null || dob.length == 0) {
      _dobController.sink.addError("Enter your Date of Birth");
      return false;
    }
    _dobController.sink.add("");

    if (streetAddress == null || streetAddress.length == 0) {
      _streetAddressController.sink.addError("Enter your Street Address");
      return false;
    }
    _streetAddressController.sink.add("");

    if (city == null || city.length == 0) {
      _cityController.sink.addError("Enter your City");
      return false;
    }
    _cityController.sink.add("");

    if (state == null || state.length == 0) {
      _stateController.sink.addError("Enter your State");
      return false;
    }

    _stateController.sink.add("");

    if (zip == null || zip.length < 5 || zip.length > 5) {
      _zipController.sink.addError("Enter correct ZIP");
      return false;
    }
    _zipController.sink.add("");

    return true;
  }

  bool isValidLicense(
      String licenseNumber, String licenseState, String licenseDate, String vehicleColor, String vehicleType) {
    if (licenseNumber == null || licenseNumber.length == 0) {
      _licenseNumberController.sink.addError("Enter correct License Number ");
      return false;
    }
    _licenseNumberController.sink.add("");

    if (licenseState == null || licenseState.length == 0) {
      _licenseStateController.sink.addError("Enter the State");
      return false;
    }
    _licenseStateController.sink.add("");

    if (licenseDate == null || licenseDate.length == 0) {
      _licenseDateController.sink.addError("Enter Date");
      return false;
    }
    _licenseDateController.sink.add("");

    if (vehicleColor == null || vehicleColor.length == 0) {
      _vehicleColorController.sink.addError("Enter your Vehicle Color");
      return false;
    }
    _vehicleColorController.sink.add("");

    if (vehicleType == null || vehicleType.length == 0) {
      _vehicleTypeController.sink.addError("Enter your Vehicle Type");
      return false;
    }
    _vehicleTypeController.sink.add("");

    return true;
  }

  void signUp(String email, String pass, String phone, String name,
      Function onSuccess, Function(String) onRegisterError) {
    _fireAuth.signUp(email, pass, name, phone, onSuccess, onRegisterError);
  }

  void signUpWithFacebook(Function onSuccess, Function(String) onRegisterError)
  {
    _fireAuth.signUpWithFacebook( onSuccess, onRegisterError);
  }

  void signUpWithGoogle(Function onSuccess, Function(String) onRegisterError)
  {
    _fireAuth.signUpWithGoogle( onSuccess, onRegisterError);
  }

  void signUpWithApple(Function onSuccess, Function(String) onRegisterError)
  {
    _fireAuth.signUpWithApple( onSuccess, onRegisterError);
  }

  void signInWithFacebook(Function(String) onSuccess,
      Function(String) onSignInError) {
    _fireAuth.signInWithFacebook(onSuccess, onSignInError);
  }

  void signInWithGoogle(Function(String) onSuccess,
      Function(String) onSignInError) {
    _fireAuth.signInWithGoogle(onSuccess, onSignInError);
  }

  void signInWithApple(Function(String) onSuccess,
      Function(String) onSignInError) {
    _fireAuth.signInWithApple(onSuccess, onSignInError);
  }

  void signIn(String email, String pass, Function onSuccess,
      Function(String) onSignInError) {
    _fireAuth.signIn(email, pass, onSuccess, onSignInError);
  }

  void checkVerifyPhone(Function(String) onResult) {
    _fireAuth.checkPhoneVerification(onResult);
  }

  void dispose() {
    _nameController.close();
    _emailController.close();
    _passController.close();
    _phoneController.close();
    _firstNameController.close();
    _lastNameController.close();
    _dobController.close();
    _streetAddressController.close();
    _aptController.close();
    _cityController.close();
    _stateController.close();
    _zipController.close();
    _licenseNumberController.close();
    _licenseStateController.close();
    _licenseDateController.close();
    _vehicleColorController.close();
    _vehicleTypeController.close();
  }
}
