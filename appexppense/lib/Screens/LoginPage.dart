import 'package:appexppense/Screens/HomeScreen.dart';
import 'package:appexppense/Screens/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isLoading = false; // Add a state variable to track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Color(0xff443E3E),
        centerTitle: true,
        // title: ElevatedButton(
        //   onPressed: () {
        //     // Implement theme change functionality
        //   },
        //   child: Text('Change Theme Color'),
        // ),
      ),
      backgroundColor: Color(0xff443E3E),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          height: 148,
        ),
        Center(
          child: Text(
            'spendWise',
            style: GoogleFonts.italianno(color: Colors.white, fontSize: 73),
          ),
        ),
        SizedBox(
          height: 26,
        ),
        Text(
          'Welcome to spendWise ',
          style: GoogleFonts.inder(color: Colors.white, fontSize: 21),
        ),
        SizedBox(
          height: 11,
        ),
        Text(
          '  Where Financial Wisdom Begins',
          style: GoogleFonts.inder(color: Colors.white, fontSize: 14),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: TextFormField(
            controller: email,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Enter Your Email",
              filled: true,
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: TextFormField(
            controller: password,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              filled: true,
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
              hintText: "Enter Your Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 22,
        ),
        Container(
          width: 228,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 38, 6, 88),
            borderRadius: BorderRadius.circular(22),
          ),
          child: _isLoading
              ? CircularProgressIndicator() // Show CircularProgressIndicator if loading
              : TextButton(
                  onPressed: () {
                    _login();
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
        ),
        SizedBox(
          height: 33,
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUp()));
          },
          child: Text(
            'Create New account.',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
        // Add Google sign-in button
        // Add 'Create a new account' button
        // Add developer information
      ]),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Set loading state to true when login starts
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      // Navigate to home screen after successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false when login completes
      });
    }
  }
}
