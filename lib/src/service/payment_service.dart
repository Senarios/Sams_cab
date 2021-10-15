import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static String apiURL = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${apiURL}/payment_intents';
  static String secret = 'sk_test_51Hti88BEXyg0kPLywO3GHoaVqnGwhH9M7R1p1egxjObRviUItKKxi6kNS4bt1od2WEtGYagMr9L57S3Ep9UHoRkl00X984phiA'; //your secret from stripe dashboard
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static Future<Map<String, dynamic>> createPaymentIntent(double amount) async {
    amount = amount *100; // convert into cents
    try {
      Map<String, dynamic> body = {
        'amount': amount.round().toString(), // amount charged will be specified when the method is called
        'currency': 'usd', // the currency
        'payment_method_types[]': 'card' //card
      };
      var response =
      await http.post(
          Uri.parse(paymentApiUrl),  //api url
          body: body,  //request body
          headers: headers //headers of the request specified in the base class
      );
      return jsonDecode(response.body); //decode the response to json
    } catch (error) {
      print('Error occured : ${error.toString()}');
    }
    return null;
  }

}

class PaymentResponse {
  String message; // message from the response
  bool success; //state of the processs

  //class constructor
  PaymentResponse({this.message, this.success});
}

