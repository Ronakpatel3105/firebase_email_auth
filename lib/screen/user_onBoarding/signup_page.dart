import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../model/user_model.dart';
import 'login_page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confimpassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up'), centerTitle: true),
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Container(
              height: 200,
              child:
                  Lottie.asset('assets/images/Animation - 1698728526143.json'),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'User Name',
                  enabledBorder: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  hintText: 'Mobile No',
                  enabledBorder: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email Id',
                  enabledBorder: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  enabledBorder: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                obscureText: true,
                controller: confimpassController,
                decoration: const InputDecoration(
                  hintText: 'Confirm Password',
                  enabledBorder: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  /// Sign up
                  var auth = FirebaseAuth.instance;
                  var email = emailController.text.toString();
                  var pass = passwordController.text.toString();
                  var confimpass = confimpassController.text.toString();
                  var name = nameController.text.toString();
                  var phone = phoneNumberController.text.toString();

                  if (passwordController.text.toString() ==
                      confimpassController.text.toString()) {
                    print("password matched");

                    try {
                      var cred = await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: pass,
                      );

                      /// After Creating Account

                      var db = FirebaseFirestore.instance;
                      var userid = cred.user!.uid;
                      db.collection("users").doc(userid).set(UserModel(
                              name: name,
                              email: email,
                              phoneNumber: phone,
                              password: pass,
                              id: userid)
                          .toJson());
                      /* db.collection("users").add(UserModel(
                              name: name,
                              email: email,
                              password: pass,
                              phoneNumber: phone)
                          .toJson());*/

                      print("User Added : ${cred.user!.uid}");
                    } on FirebaseAuthException catch (e) {
                      print("Error: ${e.code}");
                    }
                    Navigator.pop(context);
                  } else if (passwordController.text.toString() !=
                      confimpassController.text.toString()) {
                    print("Error:password not matched");
                  }
                },
                child: const Text('Sign up')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyLoginPage(),
                      ));
                },
                child: const Text('Already Have an Account? Login')),
          ]),
        ),
      ),
    );
  }
}
