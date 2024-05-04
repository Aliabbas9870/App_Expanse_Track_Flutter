import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appexppense/Screens/HomeScreen.dart';
import 'package:appexppense/Screens/LoginPage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _isRegistering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff443E3E),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 33,
          ),
          Center(
            child: Text(
              'Create a New Account',
              style: GoogleFonts.inder(color: Colors.white, fontSize: 21),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: TextFormField(
              textAlign: TextAlign.center,
              controller: username,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: "Enter UserName",
                  filled: true,
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: "Enter Email",
                  filled: true,
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: TextFormField(
              controller: phone,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: "Phone Number",
                  filled: true,
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: TextFormField(
              controller: password,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: "Enter Your Password",
                  filled: true,
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          _isRegistering
              ? CircularProgressIndicator(color: Colors.greenAccent)
              : Container(
                
                  width: 228,
                  decoration: BoxDecoration(
                    
                      color: Color.fromARGB(255, 38, 6, 88),
                      borderRadius: BorderRadius.circular(22)),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _registerUser();
                    },
                    icon: Icon(Icons.person_add),
                    label: Text("Create Account"),
                  ),
                ),
          SizedBox(
            height: 25,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              'Already have an account.',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  void _registerUser() async {
    setState(() {
      _isRegistering = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': username.text.trim(),
          'email': email.text.trim(),
          'Password': password.text.trim(),
          'phoneNumber': phone.text.trim(),
          'createdAt': DateTime.now(),
        });

        // Navigate to home screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Error', 'The password provided is too weak',
            animationDuration: Duration(milliseconds: 2011),
            colorText: Colors.white);
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Error',
            'The account already exists for that email.',
            animationDuration: Duration(milliseconds: 2011),
            colorText: Colors.white);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isRegistering = false;
      });
    }
  }
}
