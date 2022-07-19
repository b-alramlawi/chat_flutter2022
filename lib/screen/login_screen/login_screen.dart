
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../providers/initializer.dart';
import '../../services/database.dart';
import '../home_screen.dart';

enum MobileVerificationState {
  showMobileFormState,
  showOtpFormState,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final otpController = TextEditingController();
final phoneController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.showMobileFormState;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId;
  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      User user = authCredential.user;
      DatabaseService().createUserData(user.phoneNumber.toString());

      setState(() {
        showLoading = false;
      });

      if (authCredential?.user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                    create: (context) => Initializer(),
                    child: const HomeScreen())));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                    create: (context) => Initializer(),
                    child: const LoginScreen())));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  getMobileFormWidget(context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 150,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              Text(""),
              Text(
                "Enter your phone number",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF5A2E02),
                    fontWeight: FontWeight.w500),
              ),
              Text(""),
              //Icon(Icons.more_vert)
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            "ChatApp will need to verify your phone number.",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(hintText: "Phone Number"),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          MaterialButton(
            color: const Color(0xFF5A2E02),
            onPressed: () async {
              setState(() {
                showLoading = true;
              });

              await _auth.verifyPhoneNumber(
                phoneNumber: phoneController.text,
                verificationCompleted: (phoneAuthCredential) async {
                  setState(() {
                    showLoading = false;
                  });
                },
                verificationFailed: (verificationFailed) async {
                  setState(() {
                    showLoading = false;
                  });
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text(verificationFailed.message)));
                },
                codeSent: (verificationId, resendingToken) async {
                  setState(() {
                    showLoading = false;
                    currentState = MobileVerificationState.showOtpFormState;
                    this.verificationId = verificationId;
                  });
                },
                codeAutoRetrievalTimeout: (verificationId) async {},
              );
            },
            child: const Text(
              "Next",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  getOtpFormWidget(context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SizedBox(
        width: size.width,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 150,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Text(""),
                Text(
                  "Verify your phone number",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF5A2E02),
                      fontWeight: FontWeight.w500),
                ),
                Text(""),
                //Icon(Icons.more_vert)
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Waiting to automatically detect an sms sent to +972595278520. Wrong number?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: <Widget>[
                  PinCodeTextField(
                    controller: otpController,
                    length: 6,
                    backgroundColor: Colors.transparent,
                    obscureText: true,
                    autoDisposeControllers: false,
                    onChanged: (pinCode) {
                      pinCode;
                    },
                    appContext: context,
                  ),
                  const Text("Enter your 6 digit code")
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            MaterialButton(
              color: const Color(0xFF5A2E02),
              onPressed: () async {
                PhoneAuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: otpController.text);

                signInWithPhoneAuthCredential(phoneAuthCredential);
              },
              child: const Text(
                "Verification",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                Container(
                  child: showLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : currentState ==
                              MobileVerificationState.showMobileFormState
                          ? getMobileFormWidget(context)
                          : getOtpFormWidget(context),
                  padding: const EdgeInsets.all(16),
                ),
              ],
            ),
          ],
        ));
  }
}

// Widget _pinCodeWidget() {
//   return Container(
//     margin: const EdgeInsets.symmetric(horizontal: 30),
//     child: Column(
//       children: <Widget>[
//         PinCodeTextField(
//           controller: otpController,
//           length: 6,
//           backgroundColor: Colors.transparent,
//           obscureText: true,
//           autoDisposeControllers: false,
//           onChanged: (pinCode) {
//             pinCode;
//           }, appContext: ,
//         ),
//         const Text("Enter your 6 digit code")
//       ],
//     ),
//   );
// }
