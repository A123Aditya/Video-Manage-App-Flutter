import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Home/MyHomePage.dart';
import 'package:myapp/Home/Phone.dart';
import 'package:myapp/Home/Videofetch/videofetch.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;

  OtpPage({required this.verificationId});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final auth = FirebaseAuth.instance;
  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < 6; i++)
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: otpControllers[i],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            // Move to the next TextField when a digit is entered
                            if (value.isNotEmpty && i < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Handle "Did not get OTP, Resend" button press
                      },
                      child: Text('Did not get OTP, Resend'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final credential = PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: otpControllers
                                .map((controller) => controller.text)
                                .join());
                        try {
                          await auth.signInWithCredential(credential);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoListPage(),
                            ),
                          );
                        } catch (e) {
                          print('Error during sign in: $e');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'Failed to sign in with the provided OTP. Please try again.'),
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
                      child: Text('Get Started'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhoneNumberPage(),
                    ));
              },
              child: Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}
