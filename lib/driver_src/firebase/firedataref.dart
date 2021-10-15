import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sam_rider_app/driver_src/models/driver.dart';
import 'package:http/http.dart' as http;
import 'package:sam_rider_app/driver_src/util/globals.dart';

import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FireDataRef {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signUp(String email, String pass, String name, String phone,
      Function onSuccess, Function(String) onRegisterError) {
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((credentials) {
      // _createUser(credentials.user.uid, name, phone, make, models, year, color,
      //     tag, onSuccess, onRegisterError);
      _createDriver(
          credentials.user.uid, name, phone, onSuccess, onRegisterError);
      print(credentials);
    }).catchError((err) {
      print(err);
      _onSignUpError(err.code, onRegisterError,err.toString());
    });
  }

  void signUpWithFacebook(
      Function onSuccess, Function(String) onRegisterError) async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(loginResult.accessToken.token);

    FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential)
        .then((credentials) {
      _createUser(credentials.user.uid, credentials.user.displayName,
          credentials.user.phoneNumber, onSuccess, onRegisterError);
      print(credentials);
    }).catchError((error) {
      _onSMSignUpError(error.code, onRegisterError);
    });
  }

  void signUpWithGoogle(
      Function onSuccess, Function(String) onRegisterError) async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    // Create a new credential
    final googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseAuth.instance
        .signInWithCredential(googleCredential)
        .then((credentials) {
      _createUser(credentials.user.uid, credentials.user.displayName,
          credentials.user.phoneNumber, onSuccess, onRegisterError);
      print(credentials);
    }).catchError((error) {
      _onSMSignUpError(error.code, onRegisterError);
    });
  }

  void signUpWithApple(
      Function onSuccess, Function(String) onRegisterError) async {
    // Trigger the authentication flow
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    FirebaseAuth.instance
        .signInWithCredential(oauthCredential)
        .then((credentials) {
          print("Apple creds");
          print(credentials);
          print(credentials.user);
      _createUser(credentials.user.uid, credentials.user.displayName,
          credentials.user.phoneNumber, onSuccess, onRegisterError);
      print(credentials);
    }).catchError((error) {
      _onSMSignUpError(error.code, onRegisterError);
    });
  }

  _createUser(String userId, String name, String phone, Function onSuccess,
      Function(String) onRegisterError) {
    var user = {
      "name": name,
      "phone": phone,
    };
    var ref = FirebaseDatabase.instance.reference().child("drivers");

    ref.child(userId).set(user).then((user) {
      // success
      onSuccess();
    }).catchError((err) {
      onRegisterError(err.toString());
    });
  }

  void checkPhoneVerification(Function(String) onSuccess) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    var ref =
    FirebaseDatabase.instance.reference().child("drivers").child(user.uid);
    DataSnapshot data = await ref.once();
    Map value = data.value;
    if (value == null) {
      await FirebaseAuth.instance.signOut();
      onSuccess("error");
    } else if (value["is_verified_phone"] == null ||
        value["is_verified_phone"] != true) {
      onSuccess(value["phone"]);
    } else {
      onSuccess("success");
    }
  }

  void signInWithFacebook(
      Function onSuccess, Function(String) onSignInError) async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(loginResult.accessToken.token);

    // Once signed in, return the UserCredential
    _firebaseAuth
        .signInWithCredential(facebookAuthCredential)
        .then((credentials) {
      var ref = FirebaseDatabase.instance.reference().child("drivers");
      ref.child(_firebaseAuth.currentUser.uid).once().then((value) {
        if (value.value != null) {
          onSuccess("success");
        } else {
          _firebaseAuth.currentUser.delete();
          onSignInError("User does not exist.");
        }
      }).catchError((error) {
        _firebaseAuth.currentUser.delete();
        onSignInError(error.toString());
      });
    }).catchError((error) {
      onSignInError(error.toString());
    });
  }

  void signInWithGoogle(Function onSuccess, Function(String) onSignInError) async
  {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    // Create a new credential
    final googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    _firebaseAuth
        .signInWithCredential(googleCredential)
        .then((credentials) {
      var ref = FirebaseDatabase.instance.reference().child("drivers");
      ref.child(_firebaseAuth.currentUser.uid).once().then((value) {
        if (value.value != null) {
          onSuccess("success");
        } else {
          _firebaseAuth.currentUser.delete();
          onSignInError("Driver does not exist.");
        }
      }).catchError((error) {
        _firebaseAuth.currentUser.delete();
        onSignInError(error.toString());
      });
    }).catchError((error) {
      onSignInError(error.toString());
    });
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }


  void signInWithApple(Function onSuccess, Function(String) onSignInError) async
  {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
   // return await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    // Once signed in, return the UserCredential
    _firebaseAuth
        .signInWithCredential(oauthCredential)
        .then((credentials) {
      var ref = FirebaseDatabase.instance.reference().child("drivers");
      ref.child(_firebaseAuth.currentUser.uid).once().then((value) {
        if (value.value != null) {
          onSuccess("success");
        } else {
          _firebaseAuth.currentUser.delete();
          onSignInError("Driver does not exist.");
        }
      }).catchError((error) {
        _firebaseAuth.currentUser.delete();
        onSignInError(error.toString());
      });
    }).catchError((error) {
      onSignInError(error.toString());
    });
  }

  void verifyPhone(String phone, Function(String) onCodeSent,
      Function(dynamic) onError) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (credential) {
          print(credential);
        },
        verificationFailed: (error) {
          onError(error);
        },
        codeSent: (String verificationId, int resendToken) {
          onCodeSent(verificationId);
          print(resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
        });
  }

  void connectPhone(String code, String verificationId, Function onCompleted,
      Function(dynamic) onError) async {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: code);
    try {
      await _firebaseAuth.currentUser
          .linkWithCredential(phoneAuthCredential)
          .then((value) {});
      var ref = FirebaseDatabase.instance.reference().child("drivers");

      ref
          .child(_firebaseAuth.currentUser.uid)
          .child("is_verified_phone")
          .set(true)
          .then((user) {
        // success
        onCompleted();
      }).catchError((err) {
        onError(err);
      });
    } catch (e) {
      onError(e);
    }
  }

  _createDriver(String userId, String name, String phone, Function onSuccess,
      Function(String) onRegisterError) {
    var user = {
      "name": name,
      "phone": phone,
    };
    var ref = FirebaseDatabase.instance.reference().child("drivers");

    ref.child(userId).set(user).then((user) {
      // success
      onSuccess();
    }).catchError((err) {
      onRegisterError(err.toString());
    });
  }

  void _onSMSignUpError(String code, Function(String) onRegisterError) {
    print(code);
    switch (code) {
      case "ERROR_INVALID_EMAIL":
      case "ERROR_INVALID_CREDENTIAL":
        onRegisterError("Invalid Email");
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "email-already-in-use":
        onRegisterError("Email has existed");
        break;
      case "ERROR_WEAK_PASSWORD":
        onRegisterError("The password is not strong enough");
        break;
      default:
        onRegisterError("Signup fail, please try again");
        break;
    }
  }

  setDriver(
      Driver driver, Function onSuccess, Function(String) onRegisterError) {
    var user = {
      "firstName": driver.firstName,
      "lastName": driver.lastName,
      "DOB": driver.dob,
      "streetAddress": driver.streetAddress,
      "Apt": driver.apartment,
      "city": driver.city,
      "state": driver.state,
      "zip": driver.zip,
      "licenseNumber": driver.licenseNumber,
      "licenseState": driver.licenseState,
      "licenseDate": driver.licenseDate,
      "vehicleColor": driver.vehicleColor,
      "vehicleType": driver.vehicleType,
      "labor": driver.preferredLabour,
      "weeklyEarning": 0.00
    };
    var ref = FirebaseDatabase.instance.reference().child("drivers");

    ref.child(_firebaseAuth.currentUser.uid).update(user).then((user) {
      List<Uint8List> imagesList = [];
      List<String> fileName = [];
      setFileName(fileName);
      setImageList(
          imagesList,
          driver.licenseFront.readAsBytesSync(),
          driver.licenseBack.readAsBytesSync(),
          driver.driverImage.readAsBytesSync());
      for (int i = 0; i < imagesList.length; i++) {
        _uploadImages(
            fileName[i], _firebaseAuth.currentUser.uid, imagesList[i]);
      }
      ;
      onSuccess();
    }).catchError((err) {
      onRegisterError(err.toString());
    });
  }

  void setFileName(fileName) {
    fileName.add("licenseFront.jpg");
    fileName.add("licenseBack.jpg");
    fileName.add("driverImage.jpg");
  }

  void setImageList(List<Uint8List> imageslist, Uint8List licenseFront,
      Uint8List licenseBack, Uint8List driverImage) {
    imageslist.add(licenseFront);
    imageslist.add(licenseBack);
    imageslist.add(driverImage);
  }

  _uploadImages(String fileName, String driverName, Uint8List data) async {
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("drivers")
        .child(driverName)
        .child(fileName);
    try {
      await storageReference.putData(data);
    } catch (e) {
      print(e);
    }
  }

  void request(
      List<LatLng> path,
      double startLat,
      double startLon,
      double endLat,
      double endLon,
      Function onSuccess,
      Function(String) onError) {
    var user = FirebaseAuth.instance.currentUser;
    var date = DateTime.now();
    var pathStr = "";
    path.forEach((element) {
      pathStr += "${element.latitude},${element.longitude}";
    });
    var request = {
      "start_lat": startLat,
      "start_lon": startLon,
      "end_lat": endLat,
      "end_lon": endLon,
      "request_date": date.millisecondsSinceEpoch,
      "state": "awaiting",
      "path": pathStr
    };
    var ref = FirebaseDatabase.instance.reference().child("requests");

    ref.child(user.uid).set(request).then((data) {
      // success
      onSuccess();
    }).catchError((err) {
      onError(err.toString());
    });
  }

  void getDriverProfile(Function(dynamic) onSuccess) {
    var user = FirebaseAuth.instance.currentUser;
    var ref =
        FirebaseDatabase.instance.reference().child("drivers").child(user.uid);
    ref.once().then((DataSnapshot data) {
      onSuccess(data.value);
    });
  }

  void getClientInfo(String clientId, Function(dynamic) onSuccess) {
    var ref =
        FirebaseDatabase.instance.reference().child("users").child(clientId);
    ref.once().then((DataSnapshot data) {
      onSuccess(data.value);
    });
  }


  void setLocation(double lat, double long) {
    if(FirebaseAuth.instance.currentUser != null) {

      var user = FirebaseAuth.instance.currentUser;

      var ref = FirebaseDatabase.instance.reference().child("drivers");

      var request = {"lat": lat, "long": long};

        ref.child(user.uid).update(request);
    }
  }

  void uploadImage(Uint8List data, Function onSuccess) async {
    var user = FirebaseAuth.instance.currentUser;

    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(user.uid + ".jpg");

    try {
      await storageReference.putData(data);
      onSuccess();
    } catch (e) {
      print(e);
    }
  }

  void getProfileImage(String uid, Function(String) onSuccess) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("drivers")
        .child(uid)
        .child("driverImage" + ".jpg");
    try {
      String profileUrl = (await ref.getDownloadURL() ?? "").toString();
      onSuccess(profileUrl);
    } catch (error) {
      print(error.toString());
    }
  }

  void signIn(String email, String pass, Function onSuccess,
      Function(String) onSignInError) {
    _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) {
      print("on SignIn in success");
      onSuccess();
    }).catchError((err) {
      print(err);
      onSignInError("SignIn fail, please try again");
    });
  }

  void _onSignUpError(String code, Function(String) onRegisterError,String error) {
    switch (code) {
      case "ERROR_INVALID_EMAIL":
      case "ERROR_INVALID_CREDENTIAL":
        onRegisterError("Invalid Email");
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        onRegisterError("Email has existed");
        break;
      case "ERROR_WEAK_PASSWORD":
        onRegisterError("The password is not strong enough");
        break;
      default:
        onRegisterError("Signup fail, please try again: "+error.toString());
        break;
    }
  }

  void getRequests(Function(dynamic) onSuccess) async {
    var ref = FirebaseDatabase.instance.reference().child("requests");
    var uid = FirebaseAuth.instance.currentUser.uid;
    try {
      var data = await ref
          .orderByChild("driver_id")
          .equalTo(uid)
          // .orderByChild("status")
          // .equalTo("waiting")
          .once();

      List<Map> maps = [];

      if (data.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(data.value);
        mapOfMaps.forEach((key, value) {
          if (value["status"] == "accepted") {
            value["data_id"] = key;
            maps.add(value);
          }
        });
      }
      print("Maps: "+maps.toString());
      onSuccess(maps);

      return;
    } catch (error) {
      print(error.toString());
    }
  }

  void getAllRequests(Function(dynamic) onSuccess) async {
    var ref = FirebaseDatabase.instance.reference().child("requests");
    var uid = FirebaseAuth.instance.currentUser.uid;
    try {
      var data = await ref
          .orderByChild("driver_id")
          .equalTo(uid)
          // .orderByChild("status")
          // .equalTo("waiting")
          .once();

      List<Map> maps = <Map>[];
      if (data.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(data.value);

        mapOfMaps.forEach((key, value) {
          // if (value["status"] == "accepted") {
          value["data_id"] = key;
          maps.add(value);
          // }
        });
      }

      onSuccess(maps);

      return;
    } catch (error) {
      print(error.toString());
    }
  }

  void saveAboutMe(
      String aboutMe, Function onSuccess, Function(dynamic) onError) async {
    var ref = FirebaseDatabase.instance.reference().child("drivers");
    var uid = FirebaseAuth.instance.currentUser.uid;
    try {
      await ref.child(uid).child("aboutme").set(aboutMe);
      onSuccess();
    } catch (error) {
      onError(error.toString());
    }
  }

  Future<String> getAboutMe() async {
    var ref = FirebaseDatabase.instance.reference().child("drivers");
    var uid = FirebaseAuth.instance.currentUser.uid;
    try {
      var aboutme = await ref.child(uid).child("aboutme").once();
      return aboutme.value;
    } catch (error) {
      return null;
    }
  }

  void acceptOffer(
      String id, Function onSuccess, Function(dynamic) onError) async {
    var ref = FirebaseDatabase.instance.reference().child("requests");
    try {
      await ref.child(id).child("status").set("accepted");
      onSuccess();
    } catch (error) {
      onError(error.toString());
    }
  }

  void rejectOffer(
      String id, Function onSuccess, Function(dynamic) onError) async {
    var ref = FirebaseDatabase.instance.reference().child("requests");
    try {
      await ref.child(id).child("status").set("rejected");
      onSuccess();
    } catch (error) {
      onError(error.toString());
    }
  }

  void completedOffer(
      String id, Function onSuccess, Function(dynamic) onError) async {
    var ref = FirebaseDatabase.instance.reference().child("requests");
   // var driverRef = FirebaseDatabase.instance.reference().child("drivers");
    try {
      await ref.child(id).child("status").set("paymentPending");
     var clientId = await ref.child(id).child("client_id").once();
     var clientToken = await FirebaseDatabase.instance.reference().child("users").child(clientId.value.toString()).child("fcmToken").once();
     notifyRideComplete(clientToken.value.toString());
      // var price = await ref.child(id).child("price").once();
      // var earning = await driverRef.child(FirebaseAuth.instance.currentUser.uid).child("weeklyEarning").once();
      // var total = price.value+earning.value;
      // await driverRef.child(FirebaseAuth.instance.currentUser.uid).child("weeklyEarning").set(total);

      onSuccess();
    } catch (error) {
      onError(error.toString());
    }
  }

  void registerEarningListener()
  {

  }


  Future<void> notifyClient(String token) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key='+Globals.serverKey,
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Driver has arrived at the pickup location',
            'title': 'SAM Rider'
          },
          'priority': 'high',
          'to': token,
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'statusCode': 1,
            'status': 'done'
           },
        },
      ),
    ).then((response) {
      print("Token: "+token);
      print("Notification: "+response.body.toString());
    });
  }

  Future<void> notifyRideComplete(String token) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key='+Globals.serverKey,
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Your current job is completed.',
            'title': 'SAM Rider'
          },
          'priority': 'high',
          'to': token,
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'statusCode': 1,
            'status': 'done'
          },
        },
      ),
    ).then((response) {
      print("Token: "+token);
      print("Notification: "+response.body.toString());
    });
  }

  Future<String> getWeeklyEarning() async {
    var ref = FirebaseDatabase.instance.reference().child("drivers");
    var uid = FirebaseAuth.instance.currentUser.uid;
    try {
      var earning = await ref.child(uid).child("weeklyEarning").once();
      return earning.value.toString();
    } catch (error) {
      return null;
    }
  }
}
