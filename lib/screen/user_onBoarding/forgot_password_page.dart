import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'login_page.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController forgotpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Container(
              child:
                  Lottie.asset('assets/images/Animation - 1698728526143.json'),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: forgotpasswordController,
                decoration: const InputDecoration(
                  hintText: ('Email Id'),
                  enabledBorder: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  var memail = forgotpasswordController.text.toString();
                  var auth = FirebaseAuth.instance;
                  try {
                    var cred = await auth.sendPasswordResetEmail(email: memail);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyLoginPage(),
                        ));
                    print("Email send");
                  } on FirebaseAuthException catch (e) {
                    print("Error:${e.code}");
                  }
                },
                child: const Text('Forgot Password')),
          ]),
        ),
      ),
    );
  }
}
