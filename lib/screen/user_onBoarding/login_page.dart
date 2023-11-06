import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../home_page.dart';
import 'forgot_password_page.dart';
import 'signup_page.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Login Page'),
          centerTitle: true,
          automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  height: 300,
                  child: Lottie.asset(
                      "assets/images/Animation - 1698728526143.json")),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: loginEmailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.mail_outline_outlined),
                    hintText: 'Email Id',
                    enabledBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: loginPasswordController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: Icon(Icons.visibility),
                    hintText: 'Password',
                    enabledBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    /// for login
                    var auth = FirebaseAuth.instance;
                    var email = loginEmailController.text.toString();
                    var pass = loginPasswordController.text.toString();
                    try {
                      var cred = await auth.signInWithEmailAndPassword(
                          email: email, password: pass);
                      print("Success:User Logged in....");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(id: cred.user!.uid),
                          ));
                    } on FirebaseAuthException catch (e) {
                      print("Error:${e.code}");
                    }
                  },
                  child: const Text('Login')),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPassword(),
                        ));
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ));
                  },
                  child: const Text(
                    "Don't have an account? Signup",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
