import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/Home/otp.dart';

class PhoneNumberPage extends StatefulWidget {
  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final auth = FirebaseAuth.instance;
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter phone number',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isValidPhoneNumber(phoneNumberController.text)) {
                  sendOtp(phoneNumberController.text);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Invalid Phone Number'),
                        content: Text('Please enter a valid phone number.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidPhoneNumber(String phoneNumber) {
    return phoneNumber.isNotEmpty &&
        int.tryParse(phoneNumber) != null &&
        phoneNumber.length >= 10;
  }

  sendOtp(String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumberController.text,
        verificationCompleted: (_) {},
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(
            msg: 'Verification failed. Error Code: ${e.code}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        },
        codeSent: (String verificationid, int? tokencode) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpPage(verificationId: verificationid),
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId){
          Fluttertoast.showToast(
            msg: 'Verification code auto-retrieval timeout',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        },
      );
      return true;
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }
}


/*
Future<bool> sendOtp(String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumberController.text,
        verificationCompleted: (_) {},
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(
            msg: 'Verification failed. Error Code: ${e.code}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        },
        codeSent: (String verificationid, int ?tokencode) {
          
        },
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
      return true;
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }
*/
